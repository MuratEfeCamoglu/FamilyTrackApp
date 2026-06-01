import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:familytrackapp/core/constants/app_strings.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/domain/usecases/get_persons_usecase.dart';
import 'package:familytrackapp/features/profile/domain/usecases/add_person_usecase.dart';
import 'package:familytrackapp/features/profile/domain/usecases/update_person_usecase.dart';
import 'package:familytrackapp/features/profile/domain/usecases/delete_person_usecase.dart';

part 'profile_state.dart';

/// Kişi listesi yönetimi için Cubit.
///
/// CLAUDE.md §State Management: Cubit tercih edilir.
/// Inject için: `getIt<ProfileCubit>()`
@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.getPersonsUseCase,
    required this.addPersonUseCase,
    required this.updatePersonUseCase,
    required this.deletePersonUseCase,
  }) : super(const ProfileInitial());

  final GetPersonsUseCase getPersonsUseCase;
  final AddPersonUseCase addPersonUseCase;
  final UpdatePersonUseCase updatePersonUseCase;
  final DeletePersonUseCase deletePersonUseCase;

  // ── Yükleme ───────────────────────────────────────────

  /// Kullanıcının tüm kişilerini Firestore'dan yükler.
  Future<void> loadPersons({required String userId}) async {
    if (userId.isEmpty) {
      emit(const ProfileLoaded(persons: []));
      return;
    }
    emit(const ProfileLoading());
    final result = await getPersonsUseCase(GetPersonsParams(userId: userId));
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (persons) => emit(ProfileLoaded(persons: persons)),
    );
  }

  // ── Ekleme ────────────────────────────────────────────

  /// Yeni kişi ekler ve listeyi günceller.
  Future<bool> addPerson({
    required String userId,
    required Person person,
  }) async {
    if (userId.isEmpty) {
      emit(const ProfileError(message: AppStrings.errorAuthRequired));
      return false;
    }

    final currentPersons = _currentPersons;
    final result = await addPersonUseCase(
      AddPersonParams(userId: userId, person: person),
    );
    return result.fold(
      (failure) {
        emit(ProfileError(message: failure.message));
        return false;
      },
      (newPerson) {
        emit(ProfileLoaded(persons: [...currentPersons, newPerson]));
        return true;
      },
    );
  }

  // ── Güncelleme ────────────────────────────────────────

  /// Mevcut kişiyi günceller.
  Future<bool> updatePerson({
    required String userId,
    required Person person,
  }) async {
    final currentPersons = _currentPersons;
    final result = await updatePersonUseCase(
      UpdatePersonParams(userId: userId, person: person),
    );
    return result.fold(
      (failure) {
        emit(ProfileError(message: failure.message));
        return false;
      },
      (updated) {
        final updated_ = currentPersons
            .map((p) => p.id == updated.id ? updated : p)
            .toList();
        emit(ProfileLoaded(persons: updated_));
        return true;
      },
    );
  }

  // ── Silme ─────────────────────────────────────────────

  /// Kişiyi siler ve listeden çıkarır.
  Future<bool> deletePerson({
    required String userId,
    required String personId,
  }) async {
    final currentPersons = _currentPersons;
    final result = await deletePersonUseCase(
      DeletePersonParams(userId: userId, personId: personId),
    );
    return result.fold(
      (failure) {
        emit(ProfileError(message: failure.message));
        return false;
      },
      (_) {
        emit(
          ProfileLoaded(
            persons: currentPersons.where((p) => p.id != personId).toList(),
          ),
        );
        return true;
      },
    );
  }

  // ── Yardımcı ──────────────────────────────────────────

  List<Person> get _currentPersons =>
      state is ProfileLoaded ? (state as ProfileLoaded).persons : [];
}
