import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary — Sleek Premium Silver/Slate Grey (not black, not dark charcoal)
  static const Color primary       = Color(0xFF7D7D82);  // elegant medium grey
  static const Color primaryLight  = Color(0xFFEBEBF0);  // very soft light grey
  static const Color primaryMuted  = Color(0xFFA2A2A7);  // elegant muted grey

  // Background
  static const Color background    = Color(0xFFF4F4F6);  // extremely clean silver-white background
  static const Color surface       = Color(0xFFFFFFFF);  // pure white for cards
  static const Color surfaceAlt    = Color(0xFFEBEBF0);  // separating surface, input backgrounds

  // Text
  static const Color textPrimary   = Color(0xFF2C2C2E);  // readable soft off-black/graphite (never pure pitch black)
  static const Color textSecondary = Color(0xFF7D7D82);  // medium grey for labels
  static const Color textMuted     = Color(0xFFC7C7CC);  // light grey for hints/disabled

  // Accent — Sleek Grey/Silver
  static const Color accent        = Color(0xFF7D7D82);

  // Timeline
  static const Color timelineDot   = Color(0xFF7D7D82);
  static const Color timelineLine  = Color(0xFFE5E5EA);

  // Semantic
  static const Color danger        = Color(0xFFE05252);  // elegant muted crimson (not aggressive bright red)
  static const Color success       = Color(0xFF63BA7F);  // elegant soft green
  static const Color divider       = Color(0xFFE5E5EA);
}
