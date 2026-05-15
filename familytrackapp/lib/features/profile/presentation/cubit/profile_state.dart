part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

/// Başlangıç durumu — henüz hiçbir şey yüklenmedi.
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Kişi listesi yükleniyor.
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Kişi listesi yüklendi.
class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.persons});

  final List<Person> persons;

  bool get isEmpty => persons.isEmpty;

  @override
  List<Object?> get props => [persons];
}

/// Hata durumu.
class ProfileError extends ProfileState {
  const ProfileError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
