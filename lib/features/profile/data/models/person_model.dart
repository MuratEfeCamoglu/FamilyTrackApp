import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';

/// Firestore ↔ Person dönüşüm modeli (data katmanı).
///
/// CLAUDE.md: `Timestamp` her zaman `FieldValue.serverTimestamp()` ile yazılır.
class PersonModel {
  const PersonModel({
    required this.id,
    required this.name,
    required this.relationshipType,
    required this.startDate,
    required this.createdAt,
    this.profileImageUrl,
  });

  final String id;
  final String name;
  final RelationshipType relationshipType;
  final String? profileImageUrl;
  final DateTime startDate;
  final DateTime createdAt;

  // ── Firestore → Model ────────────────────────────────
  factory PersonModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return PersonModel(
      id: doc.id,
      name: d['name'] as String,
      relationshipType: RelationshipTypeX.fromString(
          d['relationshipType'] as String? ?? ''),
      profileImageUrl: d['profileImageUrl'] as String?,
      startDate: (d['startDate'] as Timestamp).toDate(),
      createdAt: (d['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  // ── Entity → Model ───────────────────────────────────
  factory PersonModel.fromEntity(Person entity) => PersonModel(
        id: entity.id,
        name: entity.name,
        relationshipType: entity.relationshipType,
        profileImageUrl: entity.profileImageUrl,
        startDate: entity.startDate,
        createdAt: entity.createdAt,
      );

  // ── Model → Firestore ────────────────────────────────
  /// Yeni döküman eklerken kullanılır.
  Map<String, dynamic> toMap() => {
        'name': name,
        'relationshipType': relationshipType.name,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        'startDate': Timestamp.fromDate(startDate),
        'createdAt': FieldValue.serverTimestamp(),
      };

  /// Güncelleme için — id ve createdAt hariç.
  Map<String, dynamic> toUpdateMap() => {
        'name': name,
        'relationshipType': relationshipType.name,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        'startDate': Timestamp.fromDate(startDate),
      };

  // ── Model → Entity ───────────────────────────────────
  Person toEntity() => Person(
        id: id,
        name: name,
        relationshipType: relationshipType,
        profileImageUrl: profileImageUrl,
        startDate: startDate,
        createdAt: createdAt,
      );
}
