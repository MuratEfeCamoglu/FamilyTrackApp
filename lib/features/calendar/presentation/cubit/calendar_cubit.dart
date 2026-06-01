import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:familytrackapp/features/profile/domain/entities/special_day_entity.dart';
import 'package:familytrackapp/features/profile/domain/usecases/special_day_usecases.dart';
import 'package:familytrackapp/core/utils/national_holidays.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/domain/usecases/get_persons_usecase.dart';

part 'calendar_state.dart';

/// Takvim sayfası için Cubit.
///
/// Tüm kişilerin özel günlerini yükler, ay navigasyonunu ve
/// gün seçimini yönetir.
@injectable
class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({
    required this.getAllSpecialDaysUseCase,
    required this.getPersonsUseCase,
  }) : super(const CalendarInitial());

  final GetAllSpecialDaysUseCase getAllSpecialDaysUseCase;
  final GetPersonsUseCase getPersonsUseCase;

  // ── Yükleme ───────────────────────────────────────────

  Future<void> loadCalendar(String userId) async {
    emit(const CalendarLoading());
    final nationalHolidays = NationalHolidays.getHolidaysForYear(DateTime.now().year);
    
    if (userId.isEmpty) {
      emit(CalendarLoaded(
        allSpecialDays: nationalHolidays,
        persons: const [],
        displayedMonth: DateTime.now(),
      ));
      return;
    }
    
    // Load persons and special days in parallel
    final result = await getAllSpecialDaysUseCase(
      GetAllSpecialDaysParams(userId: userId),
    );
    final personsResult = await getPersonsUseCase(
      GetPersonsParams(userId: userId),
    );

    final persons = personsResult.fold((_) => <Person>[], (p) => p);

    result.fold(
      (failure) => emit(CalendarError(message: failure.message)),
      (days) => emit(CalendarLoaded(
        allSpecialDays: [...days, ...nationalHolidays],
        persons: persons,
        displayedMonth: DateTime.now(),
      )),
    );
  }

  // ── Ay Navigasyonu ────────────────────────────────────

  void previousMonth() {
    final s = state;
    if (s is! CalendarLoaded) return;
    final prev = DateTime(s.displayedMonth.year, s.displayedMonth.month - 1);
    emit(s.copyWith(displayedMonth: prev, clearSelected: true));
  }

  void nextMonth() {
    final s = state;
    if (s is! CalendarLoaded) return;
    final next = DateTime(s.displayedMonth.year, s.displayedMonth.month + 1);
    emit(s.copyWith(displayedMonth: next, clearSelected: true));
  }

  void goToToday() {
    final s = state;
    if (s is! CalendarLoaded) return;
    emit(s.copyWith(displayedMonth: DateTime.now(), clearSelected: true));
  }

  // ── Gün Seçimi ────────────────────────────────────────

  void setPersonFilter(String? personId) {
    final s = state;
    if (s is! CalendarLoaded) return;
    emit(s.copyWith(
      selectedPersonId: personId,
      clearSelectedPerson: personId == null,
    ));
  }

  void selectDate(DateTime date) {
    final s = state;
    if (s is! CalendarLoaded) return;
    // Aynı gün tekrar seçilirse seçimi kaldır
    final isSame = s.selectedDate != null &&
        s.selectedDate!.day == date.day &&
        s.selectedDate!.month == date.month &&
        s.selectedDate!.year == date.year;
    emit(isSame
        ? s.copyWith(clearSelected: true)
        : s.copyWith(selectedDate: date));
  }
}
