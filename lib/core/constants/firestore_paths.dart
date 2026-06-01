/// Firestore koleksiyon ve döküman yolları.
///
/// CLAUDE.md kural: Hardcoded string yerine bu sabitler kullanılır.
/// Veri modeli:
/// ```
/// users/{userId}
///   ├── persons/{personId}
///   │     ├── details/{detailId}
///   │     └── specialDays/{dayId}
///   └── moments/{momentId}
/// ```
class FirestorePaths {
  FirestorePaths._();

  // ── Koleksiyon isimleri ───────────────────────────────

  /// `users` üst koleksiyonu
  static const String users = 'users';

  /// `persons` alt koleksiyonu (users/{uid}/persons)
  static const String persons = 'persons';

  /// `details` alt koleksiyonu (users/{uid}/persons/{pid}/details)
  static const String details = 'details';

  /// `specialDays` alt koleksiyonu (users/{uid}/persons/{pid}/specialDays)
  static const String specialDays = 'specialDays';

  /// `moments` alt koleksiyonu (users/{uid}/moments)
  static const String moments = 'moments';

  // ── Yardımcı path builder'lar ─────────────────────────

  /// `users/{userId}` döküman yolu
  static String userDoc(String userId) => '$users/$userId';

  /// `users/{userId}/persons` koleksiyon yolu
  static String personsCol(String userId) => '$users/$userId/$persons';

  /// `users/{userId}/persons/{personId}` döküman yolu
  static String personDoc(String userId, String personId) =>
      '$users/$userId/$persons/$personId';

  /// `users/{userId}/persons/{personId}/details` koleksiyon yolu
  static String detailsCol(String userId, String personId) =>
      '$users/$userId/$persons/$personId/$details';

  /// `users/{userId}/persons/{personId}/specialDays` koleksiyon yolu
  static String specialDaysCol(String userId, String personId) =>
      '$users/$userId/$persons/$personId/$specialDays';

  /// `users/{userId}/moments` koleksiyon yolu
  static String momentsCol(String userId) => '$users/$userId/$moments';

  /// `users/{userId}/moments/{momentId}` döküman yolu
  static String momentDoc(String userId, String momentId) =>
      '$users/$userId/$moments/$momentId';
}
