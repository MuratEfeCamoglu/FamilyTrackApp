import 'package:flutter/material.dart';
import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';

/// Tekrar kullanılabilir `BoxDecoration` ve `BoxShadow` token'ları.
///
/// CLAUDE.md: Magic number yasak; tüm dekorasyon değerleri buradan gelir.
/// Kullanım: `Container(decoration: AppDecorations.card)`
class AppDecorations {
  AppDecorations._();

  // ─────────────────────────────────────────────────────────
  // Gölgeler
  // ─────────────────────────────────────────────────────────

  /// Kart için hafif pembe gölge
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x14E91E8C), // primary %8
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Yüksek kart / modal gölge
  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x1AE91E8C), // primary %10
      blurRadius: 32,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A1A1A2E), // textPrimary %4
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// BottomNav üst gölge
  static const List<BoxShadow> bottomNavShadow = [
    BoxShadow(
      color: Color(0x1AE91E8C),
      blurRadius: 16,
      offset: Offset(0, -4),
      spreadRadius: 0,
    ),
  ];

  /// FAB / Pill button gölge
  static const List<BoxShadow> pillShadow = [
    BoxShadow(
      color: Color(0x33E91E8C), // primary %20
      blurRadius: 20,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  // ─────────────────────────────────────────────────────────
  // Dekorasyonlar
  // ─────────────────────────────────────────────────────────

  /// Standart beyaz kart
  static const BoxDecoration card = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.all(Radius.circular(AppSpacing.md)),
    boxShadow: cardShadow,
  );

  /// Hafif pembe arka planlı kart (vurgu)
  static const BoxDecoration cardLight = BoxDecoration(
    color: AppColors.surfaceLight,
    borderRadius: BorderRadius.all(Radius.circular(AppSpacing.md)),
  );

  /// Primary renk kenarlıklı kart
  static const BoxDecoration cardBordered = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.all(Radius.circular(AppSpacing.md)),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.primaryLight, width: 1.5),
    ),
  );

  /// Hero / banner gradyan — pembe tonları
  static const BoxDecoration heroBanner = BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.primary, AppColors.primaryDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.all(Radius.circular(AppSpacing.lg)),
    boxShadow: pillShadow,
  );

  /// Yumuşak pembe gradyan arka plan (sayfa başlık bölgesi)
  static const BoxDecoration softGradientBackground = BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.surface, AppColors.background],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  /// Avatar / rozet arka planı — yuvarlak, açık pembe
  static const BoxDecoration avatarBackground = BoxDecoration(
    color: AppColors.primaryLight,
    shape: BoxShape.circle,
  );

  /// İkon arka planı — küçük yuvarlak kare
  static BoxDecoration iconBackground({
    Color color = AppColors.surfaceLight,
    double radius = AppSpacing.sm,
  }) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      );

  /// Zaman tüneli çizgisi
  static const BoxDecoration timelineLine = BoxDecoration(
    color: AppColors.timelineLine,
    borderRadius: BorderRadius.all(Radius.circular(2)),
  );

  /// Glassmorphism overlay — beyaz %60 + blur için kullanılır
  static BoxDecoration glass({double opacity = 0.6}) => BoxDecoration(
        color: AppColors.surface.withValues(alpha: opacity),
        borderRadius: const BorderRadius.all(Radius.circular(AppSpacing.md)),
        border: Border.all(
          color: AppColors.surface.withValues(alpha: 0.8),
          width: 1,
        ),
      );

  // ─────────────────────────────────────────────────────────
  // Gradyanlar (tekil kullanım)
  // ─────────────────────────────────────────────────────────

  /// Pembe → koyu pembe — ana CTA gradyanı
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Açık pembe → arka plan — sayfa başlığı
  static const LinearGradient softGradient = LinearGradient(
    colors: [AppColors.primaryLight, AppColors.background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Beyaz → krem — BottomNav üstü
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [AppColors.surface, AppColors.background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
