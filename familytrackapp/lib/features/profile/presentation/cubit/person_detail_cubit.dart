import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_detail_entity.dart';
import 'package:familytrackapp/features/profile/domain/usecases/person_detail_usecases.dart';

part 'person_detail_state.dart';

/// Kişi detay bilgilerini yöneten Cubit.
@injectable
class PersonDetailCubit extends Cubit<PersonDetailState> {
  PersonDetailCubit({
    required this.getPersonDetailsUseCase,
    required this.addPersonDetailUseCase,
    required this.deletePersonDetailUseCase,
  }) : super(const PersonDetailInitial());

  final GetPersonDetailsUseCase getPersonDetailsUseCase;
  final AddPersonDetailUseCase addPersonDetailUseCase;
  final DeletePersonDetailUseCase deletePersonDetailUseCase;

  // ── Yükleme ───────────────────────────────────────────

  Future<void> loadDetails({
    required String userId,
    required Person person,
  }) async {
    emit(const PersonDetailLoading());
    final result = await getPersonDetailsUseCase(
      GetPersonDetailsParams(userId: userId, personId: person.id),
    );
    result.fold(
      (failure) => emit(PersonDetailError(message: failure.message)),
      (details) => emit(PersonDetailLoaded(person: person, details: details)),
    );
  }

  // ── Ekleme ────────────────────────────────────────────

  Future<void> addDetail({
    required String userId,
    required PersonDetail detail,
  }) async {
    final current = _current;
    if (current == null) return;

    final result = await addPersonDetailUseCase(
      AddPersonDetailParams(
        userId: userId,
        personId: current.person.id,
        detail: detail,
      ),
    );
    result.fold(
      (failure) => emit(PersonDetailError(message: failure.message)),
      (newDetail) => emit(PersonDetailActionSuccess(
        person: current.person,
        details: [...current.details, newDetail],
        successMessage: 'Bilgi eklendi.',
      )),
    );
  }

  // ── Silme ─────────────────────────────────────────────

  Future<void> deleteDetail({
    required String userId,
    required String detailId,
  }) async {
    final current = _current;
    if (current == null) return;

    final result = await deletePersonDetailUseCase(
      DeletePersonDetailParams(
        userId: userId,
        personId: current.person.id,
        detailId: detailId,
      ),
    );
    result.fold(
      (failure) => emit(PersonDetailError(message: failure.message)),
      (_) => emit(PersonDetailActionSuccess(
        person: current.person,
        details: current.details.where((d) => d.id != detailId).toList(),
        successMessage: 'Bilgi silindi.',
      )),
    );
  }

  // ── Yardımcı ──────────────────────────────────────────

  PersonDetailLoaded? get _current {
    final s = state;
    if (s is PersonDetailLoaded) return s;
    if (s is PersonDetailActionSuccess) {
      return PersonDetailLoaded(person: s.person, details: s.details);
    }
    return null;
  }
}
