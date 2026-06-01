import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_detail_entity.dart';

/// Firestore ↔ PersonDetail dönüşüm modeli.
class PersonDetailModel {
  const PersonDetailModel({
    required this.id,
    required this.personId,
    required this.key,
    required this.value,
    required this.createdAt,
    this.icon,
  });

  final String id;
  final String personId;
  final String key;
  final String value;
  final String? icon;
  final DateTime createdAt;

  factory PersonDetailModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
    String personId,
  ) {
    final d = doc.data()!;
    return PersonDetailModel(
      id: doc.id,
      personId: personId,
      key: d['key'] as String,
      value: d['value'] as String,
      icon: d['icon'] as String?,
      createdAt: (d['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  factory PersonDetailModel.fromEntity(PersonDetail entity) => PersonDetailModel(
        id: entity.id,
        personId: entity.personId,
        key: entity.key,
        value: entity.value,
        icon: entity.icon,
        createdAt: entity.createdAt,
      );

  Map<String, dynamic> toMap() => {
        'key': key,
        'value': value,
        if (icon != null) 'icon': icon,
        'createdAt': FieldValue.serverTimestamp(),
      };

  PersonDetail toEntity() => PersonDetail(
        id: id,
        personId: personId,
        key: key,
        value: value,
        icon: icon,
        createdAt: createdAt,
      );
}
