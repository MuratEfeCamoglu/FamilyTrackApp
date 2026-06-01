import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:familytrackapp/core/constants/default_categories.dart';
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

  // ── Yardımcı Kategoriler Birleştirme ─────────────────

  List<PersonDetail> _mergeWithDefaultCategories(Person person, List<PersonDetail> details) {
    final merged = <PersonDetail>[...details];
    for (var item in DefaultCategories.items) {
      final label = item['label']!;
      final icon = item['icon']!;
      final key = item['key']!;
      
      // Eğer bu etiketle bir detay zaten yoksa, geçici boş bir detay ekle
      if (!merged.any((d) => d.key.toLowerCase() == label.toLowerCase())) {
        merged.add(
          PersonDetail(
            id: 'temp_$key', // geçici ID
            personId: person.id,
            key: label,
            value: '',
            icon: icon,
            createdAt: DateTime.now(),
          ),
        );
      }
    }
    return merged;
  }

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
      (details) {
        final merged = _mergeWithDefaultCategories(person, details);
        emit(PersonDetailLoaded(person: person, details: merged));
      },
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
      (newDetail) {
        final newRealDetails = [...current.details, newDetail];
        final merged = _mergeWithDefaultCategories(current.person, newRealDetails);
        emit(PersonDetailActionSuccess(
          person: current.person,
          details: merged,
          successMessage: 'Bilgi eklendi.',
        ));
      },
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
      (_) {
        final remainingReal = current.details.where((d) => d.id != detailId).toList();
        final merged = _mergeWithDefaultCategories(current.person, remainingReal);
        emit(PersonDetailActionSuccess(
          person: current.person,
          details: merged,
          successMessage: 'Bilgi silindi.',
        ));
      },
    );
  }

  // ── Yardımcı ──────────────────────────────────────────

  PersonDetailLoaded? get _current {
    final s = state;
    if (s is PersonDetailLoaded) {
      return PersonDetailLoaded(
        person: s.person,
        details: s.details.where((d) => !d.id.startsWith('temp_')).toList(),
      );
    }
    if (s is PersonDetailActionSuccess) {
      return PersonDetailLoaded(
        person: s.person,
        details: s.details.where((d) => !d.id.startsWith('temp_')).toList(),
      );
    }
    return null;
  }
}
