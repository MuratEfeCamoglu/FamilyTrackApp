import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:familytrackapp/features/moments/domain/entities/moment_entity.dart';
import 'package:familytrackapp/features/moments/domain/usecases/moment_usecases.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/domain/entities/special_day_entity.dart';
import 'package:familytrackapp/features/profile/domain/usecases/get_persons_usecase.dart';
import 'package:familytrackapp/features/profile/domain/usecases/special_day_usecases.dart';
import 'package:familytrackapp/core/utils/national_holidays.dart';

part 'today_state.dart';

/// Bugün sayfası için Cubit — seçili kişiyi ve ilgili verileri yönetir.
///
/// _MainShell düzeyinde BlocProvider ile sağlanır, böylece
/// hem TodayPage hem de AppBottomNav aynı state'i okuyabilir.
@injectable
class TodayCubit extends Cubit<TodayState> {
  TodayCubit({
    required this.getPersonsUseCase,
    required this.getSpecialDaysUseCase,
    required this.getMomentsByPersonUseCase,
  }) : super(const TodayInitial());

  final GetPersonsUseCase getPersonsUseCase;
  final GetSpecialDaysUseCase getSpecialDaysUseCase;
  final GetMomentsByPersonUseCase getMomentsByPersonUseCase;

  // ── Başlatma ──────────────────────────────────────────

  /// İlk kişi listesini yükler ve ilk kişiyi seçer.
  Future<void> initialize(String userId) async {
    if (userId.isEmpty) {
      emit(const TodayNoPersons());
      return;
    }
    emit(const TodayLoading());
    final result = await getPersonsUseCase(GetPersonsParams(userId: userId));
    await result.fold(
      (failure) async => emit(TodayError(message: failure.message)),
      (persons) async {
        if (persons.isEmpty) {
          emit(const TodayNoPersons());
          return;
        }
        await _loadData(userId: userId, persons: persons, selected: persons.first);
      },
    );
  }

  // ── Kişi Seçimi ───────────────────────────────────────

  /// Seçili kişiyi değiştirir ve verilerini yeniden yükler.
  Future<void> selectPerson(String userId, Person person) async {
    final currentPersons =
        state is TodayLoaded ? (state as TodayLoaded).allPersons : <Person>[];
    await _loadData(userId: userId, persons: currentPersons, selected: person);
  }

  // ── Veri Yenileme ─────────────────────────────────────

  /// Seçili kişinin verilerini Firestore'dan yeniler.
  Future<void> refresh(String userId) async {
    final current = state;
    if (current is! TodayLoaded) return;
    await _loadData(
        userId: userId,
        persons: current.allPersons,
        selected: current.selectedPerson);
  }

  // ── İç Yardımcı ───────────────────────────────────────

  Future<void> _loadData({
    required String userId,
    required List<Person> persons,
    required Person selected,
  }) async {
    // Özel günler ve anları paralel çek
    final daysResult = await getSpecialDaysUseCase(
      GetSpecialDaysParams(userId: userId, personId: selected.id),
    );
    final momentsResult = await getMomentsByPersonUseCase(
      GetMomentsByPersonParams(userId: userId, personId: selected.id),
    );

    final days = daysResult.fold((_) => <SpecialDay>[], (d) => d);
    final moments = momentsResult.fold((_) => <Moment>[], (m) => m);

    final nationalHolidays = NationalHolidays.getHolidaysForYear(DateTime.now().year);
    final allDays = [...days, ...nationalHolidays];

    // daysUntilNext'e göre sırala, max 5
    final upcomingDays = (List<SpecialDay>.from(allDays)
          ..sort((a, b) => a.daysUntilNext.compareTo(b.daysUntilNext)))
        .take(5)
        .toList();

    emit(TodayLoaded(
      allPersons: persons,
      selectedPerson: selected,
      upcomingDays: upcomingDays,
      recentMoments: moments.take(5).toList(),
    ));
  }
}
