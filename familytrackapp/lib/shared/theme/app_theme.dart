import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:familytrackapp/core/constants/app_colors.dart';
import 'package:familytrackapp/core/constants/app_spacing.dart';

/// Uygulamanın tek `ThemeData` kaynağı (single source of truth).
///
/// CLAUDE.md §Tasarım Sistemi: token tabanlı tema yönetimi.
/// - Başlıklar: Nunito (w600–w900)
/// - Gövde: DM Sans (w400–w700)
/// - Tüm renkler AppColors'tan, tüm ölçüler AppSpacing/AppRadius'tan gelir.
///
/// Kullanım: `MaterialApp(theme: AppTheme.light)`
class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────────────────
  // TextTheme — Nunito (display/headline) + DM Sans (body/label)
  // ─────────────────────────────────────────────────────────
  static TextTheme get _textTheme => TextTheme(
        // ── Display ──────────────────────────────────────
        displayLarge: GoogleFonts.nunito(
          fontSize: 57,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryDark,
          letterSpacing: -0.25,
        ),
        displayMedium: GoogleFonts.nunito(
          fontSize: 45,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryDark,
        ),
        displaySmall: GoogleFonts.nunito(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
        // ── Headline ─────────────────────────────────────
        headlineLarge: GoogleFonts.nunito(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryDark,
        ),
        headlineMedium: GoogleFonts.nunito(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryDark,
        ),
        headlineSmall: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        // ── Title ────────────────────────────────────────
        titleLarge: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.15,
        ),
        titleSmall: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.1,
        ),
        // ── Body ─────────────────────────────────────────
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          letterSpacing: 0.25,
        ),
        bodySmall: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          letterSpacing: 0.4,
        ),
        // ── Label ────────────────────────────────────────
        labelLarge: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.1,
        ),
        labelMedium: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          letterSpacing: 1.2,
        ),
      );

  // ─────────────────────────────────────────────────────────
  // ColorScheme
  // ─────────────────────────────────────────────────────────
  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    // Primary — canlı pembe
    primary: AppColors.primary,
    onPrimary: AppColors.surface,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    // Secondary — koyu pembe
    secondary: AppColors.primaryDark,
    onSecondary: AppColors.surface,
    secondaryContainer: AppColors.surfaceLight,
    onSecondaryContainer: AppColors.textPrimary,
    // Tertiary — vurgu ton
    tertiary: Color(0xFFFF6B9D),
    onTertiary: AppColors.surface,
    tertiaryContainer: Color(0xFFFFD6E7),
    onTertiaryContainer: AppColors.primaryDark,
    // Error
    error: AppColors.danger,
    onError: AppColors.surface,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    // Surface
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.background,
    onSurfaceVariant: AppColors.textSecondary,
    // Outline
    outline: AppColors.primaryLight,
    outlineVariant: Color(0xFFE8D0DB),
    // Misc
    shadow: Color(0x1AE91E8C),
    scrim: Color(0x521A1A2E),
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.surface,
    inversePrimary: AppColors.primaryLight,
  );

  // ─────────────────────────────────────────────────────────
  // Açık Tema
  // ─────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: _colorScheme,
        textTheme: _textTheme,
        scaffoldBackgroundColor: AppColors.background,

        // ── AppBar ──────────────────────────────────────────
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.primaryDark,
          elevation: 0,
          scrolledUnderElevation: 1,
          shadowColor: AppColors.primaryLight.withValues(alpha: 0.5),
          centerTitle: false,
          titleSpacing: AppSpacing.md,
          titleTextStyle: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
          iconTheme: const IconThemeData(
            color: AppColors.primaryDark,
            size: 24,
          ),
          actionsIconTheme: const IconThemeData(
            color: AppColors.primary,
            size: 24,
          ),
        ),

        // ── Card ────────────────────────────────────────────
        cardTheme: const CardThemeData(
          color: AppColors.surface,
          shadowColor: Color(0x14E91E8C),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSpacing.md)),
          ),
          margin: EdgeInsets.zero,
        ),

        // ── Elevated Button ─────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surface,
            disabledBackgroundColor: AppColors.primaryLight,
            disabledForegroundColor: AppColors.surface,
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm + 6,
            ),
            minimumSize: const Size(88, 48),
            shape: const StadiumBorder(),
            textStyle: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // ── Outlined Button ─────────────────────────────────
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm + 6,
            ),
            minimumSize: const Size(88, 48),
            shape: const StadiumBorder(),
            textStyle: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // ── Text Button ─────────────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            textStyle: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),

        // ── Icon Button ─────────────────────────────────────
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            highlightColor: AppColors.primaryLight.withValues(alpha: 0.3),
          ),
        ),

        // ── Input Decoration ────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLight,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 6,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.danger, width: 2),
          ),
          hintStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          ),
          labelStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          floatingLabelStyle: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          errorStyle: GoogleFonts.dmSans(
            fontSize: 12,
            color: AppColors.danger,
          ),
          prefixIconColor: AppColors.textSecondary,
          suffixIconColor: AppColors.textSecondary,
        ),

        // ── Bottom Navigation Bar ────────────────────────────
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedIconTheme: const IconThemeData(size: 26),
          unselectedIconTheme: const IconThemeData(size: 24),
          selectedLabelStyle: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),

        // ── List Tile ────────────────────────────────────────
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          titleTextStyle: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          subtitleTextStyle: GoogleFonts.dmSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
          iconColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
        ),

        // ── Divider ─────────────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: Color(0xFFEEDEE6),
          thickness: 1,
          space: 1,
        ),

        // ── Chip ────────────────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceLight,
          selectedColor: AppColors.primaryLight,
          disabledColor: AppColors.surfaceLight,
          deleteIconColor: AppColors.primaryDark,
          labelStyle: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          secondaryLabelStyle: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 4,
            vertical: AppSpacing.xs,
          ),
          shape: const StadiumBorder(),
          side: BorderSide.none,
        ),

        // ── Floating Action Button ───────────────────────────
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          elevation: 4,
          focusElevation: 6,
          hoverElevation: 6,
          highlightElevation: 8,
          extendedPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: StadiumBorder(),
        ),

        // ── Dialog ──────────────────────────────────────────
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shadowColor: const Color(0x33E91E8C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.lg),
          ),
          titleTextStyle: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
          contentTextStyle: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),

        // ── SnackBar ────────────────────────────────────────
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.surface,
          ),
          actionTextColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 4,
        ),

        // ── Bottom Sheet ─────────────────────────────────────
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.xl),
            ),
          ),
          showDragHandle: true,
          dragHandleColor: AppColors.primaryLight,
          dragHandleSize: Size(40, 4),
        ),

        // ── Progress Indicator ───────────────────────────────
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
          circularTrackColor: AppColors.primaryLight,
          linearTrackColor: AppColors.primaryLight,
          linearMinHeight: 4,
        ),

        // ── Switch ───────────────────────────────────────────
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.surface;
            }
            return AppColors.textMuted;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return AppColors.surfaceLight;
          }),
          trackOutlineColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.transparent;
            }
            return AppColors.primaryLight;
          }),
        ),

        // ── Checkbox ─────────────────────────────────────────
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(AppColors.surface),
          side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),

        // ── Popup Menu ───────────────────────────────────────
        popupMenuTheme: PopupMenuThemeData(
          color: AppColors.surface,
          elevation: 8,
          shadowColor: const Color(0x1AE91E8C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm + 4),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),

        // ── Badge ────────────────────────────────────────────
        badgeTheme: const BadgeThemeData(
          backgroundColor: AppColors.primary,
          textColor: AppColors.surface,
          smallSize: 8,
          largeSize: 18,
        ),

        // ── Tooltip ──────────────────────────────────────────
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(AppSpacing.xs),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 12,
            color: AppColors.surface,
          ),
        ),
      );
}
