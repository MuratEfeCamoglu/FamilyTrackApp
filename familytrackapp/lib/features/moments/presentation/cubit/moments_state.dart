part of 'moments_cubit.dart';

abstract class MomentsState extends Equatable {
  const MomentsState();
  @override
  List<Object?> get props => [];
}

class MomentsInitial extends MomentsState {
  const MomentsInitial();
}

class MomentsLoading extends MomentsState {
  const MomentsLoading();
}

class MomentsLoaded extends MomentsState {
  const MomentsLoaded({
    required this.allMoments,
    required this.persons,
    this.selectedPersonId,
  });

  /// Tüm anlar — tarihe göre azalan sıralı (en yeni üstte).
  final List<Moment> allMoments;

  /// An ekleme formundaki kişi seçici için.
  final List<Person> persons;

  final String? selectedPersonId;

  List<Moment> get moments => selectedPersonId == null
      ? allMoments
      : allMoments.where((m) => m.personId == selectedPersonId).toList();

  MomentsLoaded copyWith({
    List<Moment>? allMoments,
    List<Person>? persons,
    String? selectedPersonId,
    bool clearSelectedPersonId = false,
  }) {
    return MomentsLoaded(
      allMoments: allMoments ?? this.allMoments,
      persons: persons ?? this.persons,
      selectedPersonId: clearSelectedPersonId ? null : (selectedPersonId ?? this.selectedPersonId),
    );
  }

  @override
  List<Object?> get props => [allMoments, persons, selectedPersonId];
}

class MomentsError extends MomentsState {
  const MomentsError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
