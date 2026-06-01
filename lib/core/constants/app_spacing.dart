/// Boşluk (spacing) token sabitleri.
///
/// CLAUDE.md kural: Magic number kullanımı yasak.
/// UI'da sabit rakam (`16`) yerine `AppSpacing.md` kullanılır.
class AppSpacing {
  AppSpacing._();

  /// 4 px
  static const double xs = 4;

  /// 8 px
  static const double sm = 8;

  /// 16 px — varsayılan padding/margin
  static const double md = 16;

  /// 24 px
  static const double lg = 24;

  /// 32 px
  static const double xl = 32;

  /// 48 px
  static const double xxl = 48;
}

/// Border radius token sabitleri.
class AppRadius {
  AppRadius._();

  /// Kart köşe yarıçapı — 16 px
  static const double card = 16;

  /// Pill button — tam yuvarlak kenar (100 px)
  static const double button = 100;

  /// Tam yuvarlak ikon arka planı — 50 px
  static const double icon = 50;

  /// Küçük chip/badge
  static const double chip = 8;
}
