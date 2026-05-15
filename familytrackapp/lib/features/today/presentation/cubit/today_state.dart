part of 'today_cubit.dart';

abstract class TodayState extends Equatable {
  const TodayState();
  @override
  List<Object?> get props => [];
}

/// Başlangıç — henüz hiçbir şey yüklenmedi.
class TodayInitial extends TodayState {
  const TodayInitial();
}

/// Veri yükleniyor.
class TodayLoading extends TodayState {
  const TodayLoading();
}

/// Hiç kişi eklenmemiş — kullanıcıyı profil sekmesine yönlendir.
class TodayNoPersons extends TodayState {
  const TodayNoPersons();
}

/// Tüm veriler hazır.
class TodayLoaded extends TodayState {
  const TodayLoaded({
    required this.allPersons,
    required this.selectedPerson,
    required this.upcomingDays,
    required this.recentMoments,
  });

  /// Kişi seçici paneli için tam liste.
  final List<Person> allPersons;

  /// Şu an gösterilen kişi.
  final Person selectedPerson;

  /// Yaklaşan özel günler (daysUntilNext'e göre sıralı, max 5).
  final List<SpecialDay> upcomingDays;

  /// Son anlar (tarihe göre azalan, max 5).
  final List<Moment> recentMoments;

  @override
  List<Object?> get props =>
      [allPersons, selectedPerson, upcomingDays, recentMoments];
}

/// Hata durumu.
class TodayError extends TodayState {
  const TodayError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
