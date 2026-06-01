import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:familytrackapp/features/moments/domain/entities/moment_entity.dart';
import 'package:familytrackapp/features/moments/domain/usecases/moment_usecases.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/domain/usecases/get_persons_usecase.dart';

part 'moments_state.dart';

/// Anlar sayfası için Cubit — tüm anları ve kişileri yönetir.
@injectable
class MomentsCubit extends Cubit<MomentsState> {
  MomentsCubit({
    required this.getMomentsUseCase,
    required this.getPersonsUseCase,
    required this.addMomentUseCase,
    required this.deleteMomentUseCase,
  }) : super(const MomentsInitial());

  final GetMomentsUseCase getMomentsUseCase;
  final GetPersonsUseCase getPersonsUseCase;
  final AddMomentUseCase addMomentUseCase;
  final DeleteMomentUseCase deleteMomentUseCase;

  // ── Yükleme ───────────────────────────────────────────

  Future<void> loadMoments(String userId) async {
    emit(const MomentsLoading());
    if (userId.isEmpty) {
      emit(const MomentsLoaded(allMoments: [], persons: []));
      return;
    }

    // Anlar ve kişiler paralel yüklenir
    final momentsResult =
        await getMomentsUseCase(GetMomentsParams(userId: userId));
    final personsResult =
        await getPersonsUseCase(GetPersonsParams(userId: userId));

    final moments = momentsResult.fold((_) => <Moment>[], (m) => m);
    final persons = personsResult.fold((_) => <Person>[], (p) => p);

    // En yeni en üstte
    moments.sort((a, b) => b.date.compareTo(a.date));

    emit(MomentsLoaded(allMoments: moments, persons: persons));
  }

  void setPersonFilter(String? personId) {
    final current = state;
    if (current is MomentsLoaded) {
      emit(current.copyWith(
        selectedPersonId: personId,
        clearSelectedPersonId: personId == null,
      ));
    }
  }

  // ── Ekleme ────────────────────────────────────────────

  Future<bool> addMoment({
    required String userId,
    required Moment moment,
  }) async {
    final current = state;
    final currentMoments =
        current is MomentsLoaded ? current.allMoments : <Moment>[];
    final currentPersons =
        current is MomentsLoaded ? current.persons : <Person>[];
    final currentSelectedPersonId =
        current is MomentsLoaded ? current.selectedPersonId : null;

    final result =
        await addMomentUseCase(AddMomentParams(userId: userId, moment: moment));
    return result.fold(
      (failure) {
        emit(MomentsError(message: failure.message));
        return false;
      },
      (newMoment) {
        final updated = [newMoment, ...currentMoments]
          ..sort((a, b) => b.date.compareTo(a.date));
        emit(MomentsLoaded(
          allMoments: updated,
          persons: currentPersons,
          selectedPersonId: currentSelectedPersonId,
        ));
        return true;
      },
    );
  }

  // ── Silme ─────────────────────────────────────────────

  Future<bool> deleteMoment({
    required String userId,
    required String momentId,
    String? imageUrl,
  }) async {
    final current = state;
    if (current is! MomentsLoaded) return false;

    final result = await deleteMomentUseCase(
      DeleteMomentParams(
          userId: userId, momentId: momentId, imageUrl: imageUrl),
    );
    return result.fold(
      (failure) {
        emit(MomentsError(message: failure.message));
        return false;
      },
      (_) {
        emit(current.copyWith(
          allMoments: current.allMoments.where((m) => m.id != momentId).toList(),
        ));
        return true;
      },
    );
  }
}
