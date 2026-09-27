import 'package:equatable/equatable.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';

/// Özel gün entity'si.
///
/// Firestore `users/{uid}/persons/{pid}/specialDays/{dayId}` dökümanına karşılık gelir.
class SpecialDay extends Equatable {
  const SpecialDay({
    required this.id,
    required this.personId,
    required this.title,
    required this.type,
    required this.date,
    required this.isRecurring,
    required this.createdAt,
  });

  /// Firestore döküman ID'si.
  final String id;

  /// Bağlı kişi ID'si.
  final String personId;

  /// Başlık (örn. "Annemin Doğum Günü").
  final String title;

  /// Özel gün türü.
  final SpecialDayType type;

  /// Tarih.
  final DateTime date;

  /// Her yıl tekrar eder mi? (doğum günü → true, tek seferlik → false)
  final bool isRecurring;

  /// Oluşturulma zamanı.
  final DateTime createdAt;

  /// Bu yılki kutlamaya kaç gün kaldı (recurring için).
  int get daysUntilNext {
    final DateTime now = DateTime.now();
    // Karşılaştırmalar saat bilgisi olmadan, gün bazında yapılır.
    final DateTime today = DateTime(now.year, now.month, now.day);
    if (!isRecurring) {
      return _dayDiff(DateTime(date.year, date.month, date.day), today);
    }
    DateTime next = DateTime(now.year, date.month, date.day);
    if (next.isBefore(today)) {
      next = DateTime(now.year + 1, date.month, date.day);
    }
    return _dayDiff(next, today);
  }

  /// Yaz saati geçişlerine dayanıklı gün farkı.
  static int _dayDiff(DateTime a, DateTime b) {
    return (a.difference(b).inHours / 24).round();
  }

  SpecialDay copyWith({
    String? id,
    String? personId,
    String? title,
    SpecialDayType? type,
    DateTime? date,
    bool? isRecurring,
    DateTime? createdAt,
  }) =>
      SpecialDay(
        id: id ?? this.id,
        personId: personId ?? this.personId,
        title: title ?? this.title,
        type: type ?? this.type,
        date: date ?? this.date,
        isRecurring: isRecurring ?? this.isRecurring,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props =>
      [id, personId, title, type, date, isRecurring, createdAt];
}
