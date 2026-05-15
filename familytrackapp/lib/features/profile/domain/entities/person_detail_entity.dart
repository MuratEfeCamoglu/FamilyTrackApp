import 'package:equatable/equatable.dart';

/// Kişiye özel bilgi entity'si.
///
/// Firestore `users/{uid}/persons/{pid}/details/{detailId}` dökümanına karşılık gelir.
/// Örn: key="favoriCicek", value="Gül", icon="🌹"
class PersonDetail extends Equatable {
  const PersonDetail({
    required this.id,
    required this.personId,
    required this.key,
    required this.value,
    required this.createdAt,
    this.icon,
  });

  /// Firestore döküman ID'si.
  final String id;

  /// Bağlı olduğu kişi ID'si.
  final String personId;

  /// Bilgi anahtarı (örn. "favoriCicek", "kanGrubu", "kahveTercihi").
  final String key;

  /// Bilgi değeri (örn. "Gül", "A Rh+", "Sütlü").
  final String value;

  /// İsteğe bağlı emoji/ikon (örn. "🌹", "☕").
  final String? icon;

  /// Oluşturulma zamanı.
  final DateTime createdAt;

  PersonDetail copyWith({
    String? id,
    String? personId,
    String? key,
    String? value,
    String? icon,
    DateTime? createdAt,
  }) =>
      PersonDetail(
        id: id ?? this.id,
        personId: personId ?? this.personId,
        key: key ?? this.key,
        value: value ?? this.value,
        icon: icon ?? this.icon,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [id, personId, key, value, icon, createdAt];
}
