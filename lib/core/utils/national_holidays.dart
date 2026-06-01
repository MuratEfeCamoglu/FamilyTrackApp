import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/features/profile/domain/entities/special_day_entity.dart';

class NationalHolidays {
  static List<SpecialDay> getHolidaysForYear(int year) {
    final now = DateTime.now();
    return [
      SpecialDay(
        id: 'nh_1_$year',
        personId: 'national',
        title: 'Yılbaşı',
        date: DateTime(year, 1, 1),
        type: SpecialDayType.custom,
        isRecurring: true,
        createdAt: now,
      ),
      SpecialDay(
        id: 'nh_2_$year',
        personId: 'national',
        title: 'Ulusal Egemenlik ve Çocuk Bayramı',
        date: DateTime(year, 4, 23),
        type: SpecialDayType.custom,
        isRecurring: true,
        createdAt: now,
      ),
      SpecialDay(
        id: 'nh_3_$year',
        personId: 'national',
        title: 'Emek ve Dayanışma Günü',
        date: DateTime(year, 5, 1),
        type: SpecialDayType.custom,
        isRecurring: true,
        createdAt: now,
      ),
      SpecialDay(
        id: 'nh_4_$year',
        personId: 'national',
        title: 'Atatürk\'ü Anma, Gençlik ve Spor Bayramı',
        date: DateTime(year, 5, 19),
        type: SpecialDayType.custom,
        isRecurring: true,
        createdAt: now,
      ),
      SpecialDay(
        id: 'nh_5_$year',
        personId: 'national',
        title: 'Demokrasi ve Milli Birlik Günü',
        date: DateTime(year, 7, 15),
        type: SpecialDayType.custom,
        isRecurring: true,
        createdAt: now,
      ),
      SpecialDay(
        id: 'nh_6_$year',
        personId: 'national',
        title: 'Zafer Bayramı',
        date: DateTime(year, 8, 30),
        type: SpecialDayType.custom,
        isRecurring: true,
        createdAt: now,
      ),
      SpecialDay(
        id: 'nh_7_$year',
        personId: 'national',
        title: 'Cumhuriyet Bayramı',
        date: DateTime(year, 10, 29),
        type: SpecialDayType.custom,
        isRecurring: true,
        createdAt: now,
      ),
    ];
  }
}
