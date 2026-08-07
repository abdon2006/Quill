import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quill/core/animations/app_page_transition.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'app_colors.dart';

abstract class AppTheme {
  // ── Light Theme ──────────────────────────────
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    splashColor: AppColors.lightAccentPrimary.withValues(alpha: 0.08),
    highlightColor: Colors.transparent,
    canvasColor: AppColors.lightBgPrimary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBgPrimary,
    colorScheme: const ColorScheme.light(
      surface: AppColors.lightBgSurface,
      primary: AppColors.lightAccentPrimary,
      secondary: AppColors.lightAccentMedium,
      tertiary: AppColors.lightGold,
      onSurface: AppColors.lightTextPrimary,
      onPrimary: Colors.white,
      error: AppColors.lightError,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: AppColors.lightTextPrimary,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: AppColors.lightTextPrimary,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: AppColors.lightTextPrimary,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.lightTextPrimary,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.75,
        color: AppColors.lightTextPrimary,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.lightTextSecondary,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        color: AppColors.lightTextPrimary,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.lightTextMuted,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightBgSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBgPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.lightTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBgSurface,
      selectedItemColor: AppColors.lightAccentPrimary,
      unselectedItemColor: AppColors.lightTextMuted,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightBgSurface,
      border: OutlineInputBorder(
        borderRadius: AppRadius.xl,
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: AppColors.lightTextMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightBgSurfaceAlt,
      thickness: 1,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CinematicPageTransitionsBuilder(),
        TargetPlatform.iOS: CinematicPageTransitionsBuilder(),
      },
    ),
  );

  // ── Dark Theme ───────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    splashColor: AppColors.darkAccentPrimary.withValues(alpha: 0.10),
    highlightColor: Colors.transparent,
    canvasColor: AppColors.darkBgPrimary,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBgPrimary,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.darkBgSurface,
      primary: AppColors.darkAccentPrimary,
      secondary: AppColors.darkAccentMedium,
      tertiary: AppColors.darkGold,
      onSurface: AppColors.darkTextPrimary,
      onPrimary: Colors.white,
      error: AppColors.darkError,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: AppColors.darkTextPrimary,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: AppColors.darkTextPrimary,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: AppColors.darkTextPrimary,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.darkTextPrimary,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.75,
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.darkTextSecondary,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        color: AppColors.darkTextPrimary,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.darkTextMuted,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkBgSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBgPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.darkTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBgSurface,
      selectedItemColor: AppColors.darkAccentPrimary,
      unselectedItemColor: AppColors.darkTextMuted,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkBgSurface,
      border: OutlineInputBorder(
        borderRadius: AppRadius.xl,
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: AppColors.darkTextMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBgSurfaceAlt,
      thickness: 1,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CinematicPageTransitionsBuilder(),
        TargetPlatform.iOS: CinematicPageTransitionsBuilder(),
      },
    ),
  );
}
