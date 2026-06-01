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
    required this.persons,
    required this.displayedMonth,
    this.selectedDate,
    this.selectedPersonId,
  });

  /// Tüm kişilerin özel günleri (Firestore'dan yüklendi).
  final List<SpecialDay> allSpecialDays;

  /// Kişi filtreleme için kullanılacak olan kişiler listesi.
  final List<Person> persons;

  /// Görüntülenen ay (sadece yıl+ay bilgisi kullanılır).
  final DateTime displayedMonth;

  /// Kullanıcının seçtiği gün (nullable).
  final DateTime? selectedDate;
  
  /// Kullanıcının filtrelediği kişi (nullable).
  final String? selectedPersonId;

  List<SpecialDay> get filteredSpecialDays {
    if (selectedPersonId == null) return allSpecialDays;
    return allSpecialDays.where((d) => d.personId == selectedPersonId || d.personId == 'national').toList();
  }

  /// Gösterilen ayda özel gün bulunan günlerin numaraları.
  Set<int> eventDaysForMonth(int year, int month) {
    return filteredSpecialDays
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
    return filteredSpecialDays.where((d) {
      if (d.isRecurring) {
        return d.date.day == date.day && d.date.month == date.month;
      }
      return d.date.day == date.day &&
          d.date.month == date.month &&
          d.date.year == date.year;
    }).toList();
  }

  /// Tüm özel günler daysUntilNext'e göre sıralı.
  List<SpecialDay> get upcomingSorted => List<SpecialDay>.from(filteredSpecialDays)
    ..sort((a, b) => a.daysUntilNext.compareTo(b.daysUntilNext));

  CalendarLoaded copyWith({
    List<SpecialDay>? allSpecialDays,
    List<Person>? persons,
    DateTime? displayedMonth,
    DateTime? selectedDate,
    String? selectedPersonId,
    bool clearSelected = false,
    bool clearSelectedPerson = false,
  }) =>
      CalendarLoaded(
        allSpecialDays: allSpecialDays ?? this.allSpecialDays,
        persons: persons ?? this.persons,
        displayedMonth: displayedMonth ?? this.displayedMonth,
        selectedDate: clearSelected ? null : (selectedDate ?? this.selectedDate),
        selectedPersonId: clearSelectedPerson ? null : (selectedPersonId ?? this.selectedPersonId),
      );

  @override
  List<Object?> get props => [allSpecialDays, persons, displayedMonth, selectedDate, selectedPersonId];
}

class CalendarError extends CalendarState {
  const CalendarError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
