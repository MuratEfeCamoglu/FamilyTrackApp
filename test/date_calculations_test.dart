import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/core/utils/date_extensions.dart';
import 'package:familytrackapp/features/profile/domain/entities/special_day_entity.dart';
import 'package:flutter_test/flutter_test.dart';

SpecialDay _day(DateTime date, {bool isRecurring = true}) => SpecialDay(
      id: 'id',
      personId: 'p',
      title: 'Test',
      type: SpecialDayType.birthday,
      date: date,
      isRecurring: isRecurring,
      createdAt: DateTime(2020),
    );

void main() {
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);

  group('SpecialDay.daysUntilNext', () {
    test('bugünkü tekrarlayan gün 0 döner (sonraki yıla atlamaz)', () {
      expect(_day(DateTime(1990, today.month, today.day)).daysUntilNext, 0);
    });

    test('yarınki tekrarlayan gün 1 döner', () {
      expect(_day(DateTime(1990, tomorrow.month, tomorrow.day)).daysUntilNext,
          1);
    });

    test('tek seferlik yarınki gün 1 döner', () {
      expect(_day(tomorrow, isRecurring: false).daysUntilNext, 1);
    });
  });

  group('DateTimeExtensions.daysUntilNextOccurrence', () {
    test('bugün 0 döner', () {
      expect(DateTime(1990, today.month, today.day).daysUntilNextOccurrence(),
          0);
    });

    test('yarın 1 döner', () {
      expect(
          DateTime(1990, tomorrow.month, tomorrow.day)
              .daysUntilNextOccurrence(),
          1);
    });
  });
}
