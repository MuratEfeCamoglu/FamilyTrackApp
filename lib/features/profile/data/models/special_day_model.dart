import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/features/profile/domain/entities/special_day_entity.dart';

/// Firestore ↔ SpecialDay dönüşüm modeli.
class SpecialDayModel {
  const SpecialDayModel({
    required this.id,
    required this.personId,
    required this.title,
    required this.type,
    required this.date,
    required this.isRecurring,
    required this.createdAt,
  });

  final String id;
  final String personId;
  final String title;
  final SpecialDayType type;
  final DateTime date;
  final bool isRecurring;
  final DateTime createdAt;

  factory SpecialDayModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
    String personId,
  ) {
    final d = doc.data()!;
    return SpecialDayModel(
      id: doc.id,
      personId: personId,
      title: d['title'] as String,
      type: SpecialDayTypeX.fromString(d['type'] as String? ?? ''),
      date: (d['date'] as Timestamp).toDate(),
      isRecurring: d['isRecurring'] as bool? ?? true,
      createdAt: (d['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  factory SpecialDayModel.fromEntity(SpecialDay entity) => SpecialDayModel(
        id: entity.id,
        personId: entity.personId,
        title: entity.title,
        type: entity.type,
        date: entity.date,
        isRecurring: entity.isRecurring,
        createdAt: entity.createdAt,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'type': type.name,
        'date': Timestamp.fromDate(date),
        'isRecurring': isRecurring,
        'createdAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> toUpdateMap() => {
        'title': title,
        'type': type.name,
        'date': Timestamp.fromDate(date),
        'isRecurring': isRecurring,
      };

  SpecialDay toEntity() => SpecialDay(
        id: id,
        personId: personId,
        title: title,
        type: type,
        date: date,
        isRecurring: isRecurring,
        createdAt: createdAt,
      );
}
