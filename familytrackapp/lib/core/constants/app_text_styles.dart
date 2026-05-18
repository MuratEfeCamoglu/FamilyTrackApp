import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:familytrackapp/core/constants/app_colors.dart';

/// Uygulamanın tipografi sistemi.
///
/// CLAUDE.md §Tasarım Sistemi — Tipografi bölümünden alınmıştır.
/// - Başlıklar: **Nunito** (güçlü, sıcak)
/// - Gövde metni: **DM Sans** (okunabilir, modern)
class AppTextStyles {
  AppTextStyles._();

  /// H1 — Büyük sayfa başlığı (örn. kişi adı)
  static TextStyle get h1 => GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
      );

  /// H2 — Bölüm başlığı
  static TextStyle get h2 => GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  /// H3 — Kart başlığı
  static TextStyle get h3 => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  /// Büyük sayaç — gün sayacı gibi devasa rakamlar
  static TextStyle get counter => GoogleFonts.nunito(
        fontSize: 64,
        fontWeight: FontWeight.w900,
        color: AppColors.primary,
      );

  /// Etiket — küçük, vurgulu, büyük harf (chip, badge)
  static TextStyle get label => GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        letterSpacing: 1.2,
      );

  /// Gövde — standart içerik metni
  static TextStyle get body => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  /// Gövde kalın — vurgulu gövde metni
  static TextStyle get bodyBold => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  /// Küçük — yardımcı / meta bilgi
  static TextStyle get caption => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  /// Düğme metni
  static TextStyle get button => GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.surface,
        letterSpacing: 0.5,
      );
}
