part of 'calendar_cubit.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();
  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {
  const CalendarInitial();
}

class CalendarLoading extends CalendarState {
  const CalendarLoading();
}

class CalendarLoaded extends CalendarState {
  const CalendarLoaded({
    required this.allSpecialDays,
    required this.displayedMonth,
    this.selectedDate,
  });

  /// Tüm kişilerin özel günleri (Firestore'dan yüklendi).
  final List<SpecialDay> allSpecialDays;

  /// Görüntülenen ay (sadece yıl+ay bilgisi kullanılır).
  final DateTime displayedMonth;

  /// Kullanıcının seçtiği gün (nullable).
  final DateTime? selectedDate;

  /// Gösterilen ayda özel gün bulunan günlerin numaraları.
  Set<int> eventDaysForMonth(int year, int month) {
    return allSpecialDays
        .where((d) {
          // Recurring: ayı eşleştir
          if (d.isRecurring) return d.date.month == month;
          // Tek seferlik: tam tarih eşleştir
          return d.date.month == month && d.date.year == year;
        })
        .map((d) => d.date.day)
        .toSet();
  }

  /// Seçili güne ait özel günler.
  List<SpecialDay> eventsForDate(DateTime? date) {
    if (date == null) return [];
    return allSpecialDays.where((d) {
      if (d.isRecurring) {
        return d.date.day == date.day && d.date.month == date.month;
      }
      return d.date.day == date.day &&
          d.date.month == date.month &&
          d.date.year == date.year;
    }).toList();
  }

  /// Tüm özel günler daysUntilNext'e göre sıralı.
  List<SpecialDay> get upcomingSorted => List<SpecialDay>.from(allSpecialDays)
    ..sort((a, b) => a.daysUntilNext.compareTo(b.daysUntilNext));

  CalendarLoaded copyWith({
    List<SpecialDay>? allSpecialDays,
    DateTime? displayedMonth,
    DateTime? selectedDate,
    bool clearSelected = false,
  }) =>
      CalendarLoaded(
        allSpecialDays: allSpecialDays ?? this.allSpecialDays,
        displayedMonth: displayedMonth ?? this.displayedMonth,
        selectedDate: clearSelected ? null : (selectedDate ?? this.selectedDate),
      );

  @override
  List<Object?> get props => [allSpecialDays, displayedMonth, selectedDate];
}

class CalendarError extends CalendarState {
  const CalendarError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
