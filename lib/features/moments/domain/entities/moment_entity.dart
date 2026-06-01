import 'package:equatable/equatable.dart';
import 'package:familytrackapp/core/constants/app_enums.dart';

/// An (moment) entity'si — zaman tünelinin temel birimi.
///
/// Firestore `users/{uid}/moments/{momentId}` dökümanına karşılık gelir.
class Moment extends Equatable {
  const Moment({
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

  /// Firestore döküman ID'si.
  final String id;

  /// İlişkili kişi ID'si.
  final String personId;

  /// An başlığı (örn. "İlk tatilimiz").
  final String title;

  /// An türü.
  final MomentType type;

  /// Anın yaşandığı tarih.
  final DateTime date;

  /// Firebase Storage fotoğraf URL'si.
  final String? imageUrl;

  /// Detay metni / not.
  final String? description;

  /// Rozet adı (örn. "İlk Seyahat", "1. Yıl").
  final String? badgeName;

  /// Oluşturulma zamanı.
  final DateTime createdAt;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasBadge => badgeName != null && badgeName!.isNotEmpty;

  Moment copyWith({
    String? id,
    String? personId,
    String? title,
    MomentType? type,
    DateTime? date,
    String? imageUrl,
    String? description,
    String? badgeName,
    DateTime? createdAt,
  }) =>
      Moment(
        id: id ?? this.id,
        personId: personId ?? this.personId,
        title: title ?? this.title,
        type: type ?? this.type,
        date: date ?? this.date,
        imageUrl: imageUrl ?? this.imageUrl,
        description: description ?? this.description,
        badgeName: badgeName ?? this.badgeName,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props =>
      [id, personId, title, type, date, imageUrl, description, badgeName, createdAt];
}
