import 'package:equatable/equatable.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';

/// Kişi domain entity'si — saf Dart, framework bağımlılığı yok.
///
/// Firestore `users/{uid}/persons/{personId}` dökümanına karşılık gelir.
class Person extends Equatable {
  const Person({
    required this.id,
    required this.name,
    required this.relationshipType,
    required this.startDate,
    required this.createdAt,
    this.profileImageUrl,
  });

  /// Firestore döküman ID'si.
  final String id;

  /// Kişinin adı (örn. "Annem", "Ahmet").
  final String name;

  /// İlişki türü (anne, baba, eş…).
  final RelationshipType relationshipType;

  /// Profil fotoğrafı URL'si (Firebase Storage).
  final String? profileImageUrl;

  /// Kullanıcıyla birliktelik başlangıç tarihi (gün sayacı için).
  final DateTime startDate;

  /// Firestore'a yazıldığı zaman.
  final DateTime createdAt;

  /// Birliktelik gün sayısı.
  int get daysTogether {
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day)
        .difference(DateTime(startDate.year, startDate.month, startDate.day))
        .inDays
        .abs();
  }

  Person copyWith({
    String? id,
    String? name,
    RelationshipType? relationshipType,
    String? profileImageUrl,
    DateTime? startDate,
    DateTime? createdAt,
  }) =>
      Person(
        id: id ?? this.id,
        name: name ?? this.name,
        relationshipType: relationshipType ?? this.relationshipType,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
        startDate: startDate ?? this.startDate,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props =>
      [id, name, relationshipType, profileImageUrl, startDate, createdAt];
}
