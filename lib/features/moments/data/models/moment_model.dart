import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/features/moments/domain/entities/moment_entity.dart';

/// Firestore ↔ Moment dönüşüm modeli.
class MomentModel {
  const MomentModel({
    required this.id,
    required this.personId,
    required this.title,
    required this.type,
    required this.date,
    required this.createdAt,
    this.imageUrl,
    this.description,
    this.badgeName,
  });

  final String id;
  final String personId;
  final String title;
  final MomentType type;
  final DateTime date;
  final String? imageUrl;
  final String? description;
  final String? badgeName;
  final DateTime createdAt;

  factory MomentModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return MomentModel(
      id: doc.id,
      personId: d['personId'] as String,
      title: d['title'] as String,
      type: MomentTypeX.fromString(d['type'] as String? ?? ''),
      date: (d['date'] as Timestamp).toDate(),
      imageUrl: d['imageUrl'] as String?,
      description: d['description'] as String?,
      badgeName: d['badgeName'] as String?,
      createdAt: (d['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  factory MomentModel.fromEntity(Moment entity) => MomentModel(
        id: entity.id,
        personId: entity.personId,
        title: entity.title,
        type: entity.type,
        date: entity.date,
        imageUrl: entity.imageUrl,
        description: entity.description,
        badgeName: entity.badgeName,
        createdAt: entity.createdAt,
      );

  Map<String, dynamic> toMap() => {
        'personId': personId,
        'title': title,
        'type': type.name,
        'date': Timestamp.fromDate(date),
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (description != null) 'description': description,
        if (badgeName != null) 'badgeName': badgeName,
        'createdAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> toUpdateMap() => {
        'title': title,
        'type': type.name,
        'date': Timestamp.fromDate(date),
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (description != null) 'description': description,
        if (badgeName != null) 'badgeName': badgeName,
      };

  Moment toEntity() => Moment(
        id: id,
        personId: personId,
        title: title,
        type: type,
        date: date,
        imageUrl: imageUrl,
        description: description,
        badgeName: badgeName,
        createdAt: createdAt,
      );
}
