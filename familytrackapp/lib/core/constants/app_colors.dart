import 'package:flutter/material.dart';

/// Uygulamanın tüm renk sabitleri.
///
/// CLAUDE.md §Tasarım Sistemi — Renk Paleti bölümünden alınmıştır.
/// Magic number kullanımı yasak; tüm renk referansları bu sınıftan gelir.
class AppColors {
  AppColors._();

  // ── Primary ──────────────────────────────────────────
  /// Canlı pembe — ana eylem rengi
  static const Color primary = Color(0xFFE91E8C);

  /// Açık pembe — vurgu arka planı, chip'ler
  static const Color primaryLight = Color(0xFFF8BBD9);

  /// Koyu pembe — vurgu metni, başlıklar
  static const Color primaryDark = Color(0xFF9C1465);

  // ── Background ───────────────────────────────────────
  /// Krem-pembe arka plan
  static const Color background = Color(0xFFFCF0F5);

  /// Kart yüzeyi (beyaz)
  static const Color surface = Color(0xFFFFFFFF);

  /// İkon arka planları için hafif pembe
  static const Color surfaceLight = Color(0xFFFFF0F5);

  // ── Text ─────────────────────────────────────────────
  /// Ana metin rengi
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// İkincil / yardımcı metin
  static const Color textSecondary = Color(0xFF6B7280);

  /// Soluk metin (geçmiş tarihler, devre dışı öğeler)
  static const Color textMuted = Color(0xFFADB5BD);

  // ── Timeline ─────────────────────────────────────────
  /// Zaman tüneli nokta rengi
  static const Color timelineDot = Color(0xFFE91E8C);

  /// Zaman tüneli bağlantı çizgisi
  static const Color timelineLine = Color(0xFFF8BBD9);

  // ── Semantic ─────────────────────────────────────────
  /// Hata / tehlike rengi
  static const Color danger = Color(0xFFDC2626);

  /// Başarı / onay rengi
  static const Color success = Color(0xFF16A34A);
}
