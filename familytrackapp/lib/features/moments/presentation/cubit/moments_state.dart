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
    required this.moments,
    required this.persons,
  });

  /// Tüm anlar — tarihe göre azalan sıralı (en yeni üstte).
  final List<Moment> moments;

  /// An ekleme formundaki kişi seçici için.
  final List<Person> persons;

  @override
  List<Object?> get props => [moments, persons];
}

class MomentsError extends MomentsState {
  const MomentsError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
