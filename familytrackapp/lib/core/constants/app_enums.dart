/// Uygulama genelinde kullanılan enum tipleri ve Türkçe extension'ları.
///
/// CLAUDE.md §Özel Gün Kategorileri bölümünden alınmıştır.
library app_enums;

// ─────────────────────────────────────────────────────────
// İlişki Türü
// ─────────────────────────────────────────────────────────

/// Kişi-kullanıcı ilişki türleri.
enum RelationshipType { mother, father, spouse, child, sibling, grandparent, friend, other }

extension RelationshipTypeX on RelationshipType {
  String get label => switch (this) {
        RelationshipType.mother => 'Anne',
        RelationshipType.father => 'Baba',
        RelationshipType.spouse => 'Eş / Partner',
        RelationshipType.child => 'Çocuk',
        RelationshipType.sibling => 'Kardeş',
        RelationshipType.grandparent => 'Büyükanne / Büyükbaba',
        RelationshipType.friend => 'Arkadaş',
        RelationshipType.other => 'Diğer',
      };

  String get emoji => switch (this) {
        RelationshipType.mother => '👩',
        RelationshipType.father => '👨',
        RelationshipType.spouse => '💑',
        RelationshipType.child => '👶',
        RelationshipType.sibling => '🤝',
        RelationshipType.grandparent => '👴',
        RelationshipType.friend => '😊',
        RelationshipType.other => '💙',
      };

  static RelationshipType fromString(String v) =>
      RelationshipType.values.firstWhere((e) => e.name == v,
          orElse: () => RelationshipType.other);
}

// ─────────────────────────────────────────────────────────
// Özel Gün Türü — CLAUDE.md §Özel Gün Kategorileri
// ─────────────────────────────────────────────────────────

enum SpecialDayType {
  birthday,
  anniversary,
  valentinesDay,
  newYear,
  mothersDay,
  fathersDay,
  custom,
}

extension SpecialDayTypeX on SpecialDayType {
  String get label => switch (this) {
        SpecialDayType.birthday => 'Doğum Günü',
        SpecialDayType.anniversary => 'Yıldönümü',
        SpecialDayType.valentinesDay => 'Sevgililer Günü',
        SpecialDayType.newYear => 'Yılbaşı',
        SpecialDayType.mothersDay => 'Anneler Günü',
        SpecialDayType.fathersDay => 'Babalar Günü',
        SpecialDayType.custom => 'Özel Gün',
      };

  String get emoji => switch (this) {
        SpecialDayType.birthday => '🎂',
        SpecialDayType.anniversary => '💞',
        SpecialDayType.valentinesDay => '💝',
        SpecialDayType.newYear => '🎆',
        SpecialDayType.mothersDay => '🌸',
        SpecialDayType.fathersDay => '👔',
        SpecialDayType.custom => '⭐',
      };

  static SpecialDayType fromString(String v) =>
      SpecialDayType.values.firstWhere((e) => e.name == v,
          orElse: () => SpecialDayType.custom);
}

// ─────────────────────────────────────────────────────────
// Moment Türü
// ─────────────────────────────────────────────────────────

enum MomentType { photo, note, milestone, celebration, travel, memory, other }

extension MomentTypeX on MomentType {
  String get label => switch (this) {
        MomentType.photo => 'Fotoğraf',
        MomentType.note => 'Not',
        MomentType.milestone => 'Kilometre Taşı',
        MomentType.celebration => 'Kutlama',
        MomentType.travel => 'Seyahat',
        MomentType.memory => 'Anı',
        MomentType.other => 'Diğer',
      };

  String get emoji => switch (this) {
        MomentType.photo => '📷',
        MomentType.note => '📝',
        MomentType.milestone => '🏆',
        MomentType.celebration => '🎉',
        MomentType.travel => '✈️',
        MomentType.memory => '💭',
        MomentType.other => '💫',
      };

  static MomentType fromString(String v) =>
      MomentType.values.firstWhere((e) => e.name == v,
          orElse: () => MomentType.other);
}
