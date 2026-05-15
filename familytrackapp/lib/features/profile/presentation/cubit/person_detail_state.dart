part of 'person_detail_cubit.dart';

abstract class PersonDetailState extends Equatable {
  const PersonDetailState();
  @override
  List<Object?> get props => [];
}

class PersonDetailInitial extends PersonDetailState {
  const PersonDetailInitial();
}

class PersonDetailLoading extends PersonDetailState {
  const PersonDetailLoading();
}

class PersonDetailLoaded extends PersonDetailState {
  const PersonDetailLoaded({
    required this.person,
    required this.details,
  });

  final Person person;
  final List<PersonDetail> details;

  @override
  List<Object?> get props => [person, details];
}

class PersonDetailError extends PersonDetailState {
  const PersonDetailError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Detay ekleme / silme sonrası başarı bildirimi.
class PersonDetailActionSuccess extends PersonDetailState {
  const PersonDetailActionSuccess({
    required this.person,
    required this.details,
    required this.successMessage,
  });

  final Person person;
  final List<PersonDetail> details;
  final String successMessage;

  @override
  List<Object?> get props => [person, details, successMessage];
}
