import 'package:intl/intl.dart';

/// `DateTime` için yardımcı extension metotları.
///
/// CLAUDE.md §Utils: Tarih formatlama Türkçe locale ile yapılır.
extension DateTimeExtensions on DateTime {
  // ── Formatlama ────────────────────────────────────────

  /// `15 Mayıs 2026` formatında döner (Türkçe).
  String toTurkishLong() {
    return DateFormat('d MMMM yyyy', 'tr_TR').format(this);
  }

  /// `15 May 26` — kısa format
  String toTurkishShort() {
    return DateFormat('d MMM yy', 'tr_TR').format(this);
  }

  /// `15.05.2026` — noktalı format
  String toDotFormat() {
    return DateFormat('dd.MM.yyyy').format(this);
  }

  /// `Pazartesi, 15 Mayıs` — gün adıyla birlikte
  String toDayMonthFull() {
    return DateFormat('EEEE, d MMMM', 'tr_TR').format(this);
  }

  // ── Hesaplama ─────────────────────────────────────────

  /// Bugünden kaç gün geçti (negatif = gelecek).
  int daysFrom(DateTime other) {
    final a = DateTime(year, month, day);
    final b = DateTime(other.year, other.month, other.day);
    return a.difference(b).inDays;
  }

  /// Bu yılın aynı tarihine kaç gün kaldığını hesaplar.
  /// Yıldönümleri / doğum günleri için kullanılır.
  int daysUntilNextOccurrence() {
    final now = DateTime.now();
    final thisYear = DateTime(now.year, month, day);
    final nextYear = DateTime(now.year + 1, month, day);

    final diff = thisYear.difference(now).inDays;
    if (diff >= 0) return diff;
    return nextYear.difference(now).inDays;
  }

  /// Tarih bugün mü?
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Tarih geçmişte mi?
  bool get isPast => isBefore(DateTime.now());

  /// Tarih gelecekte mi?
  bool get isFuture => isAfter(DateTime.now());

  /// Başlangıç tarihinden itibaren geçen gün sayısı (pozitif).
  int daysSince() {
    final now = DateTime.now();
    final start = DateTime(year, month, day);
    final today = DateTime(now.year, now.month, now.day);
    return today.difference(start).inDays.abs();
  }

  /// Ay kısaltması Türkçe (Oca, Şub, Mar …)
  String get monthAbbr {
    const months = [
      'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
    ];
    return months[month - 1];
  }
}
