import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  
  
  static TextStyle displayLarge(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: Theme.of(context).colorScheme.onSurface,
      );

  
  static TextStyle displayMedium(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: Theme.of(context).colorScheme.onSurface,
      );

  
  
  static TextStyle heading1(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: Theme.of(context).colorScheme.onSurface,
      );

  
  static TextStyle heading2(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600, 
        color: Theme.of(context).colorScheme.onSurface,
      );

  
  
  static TextStyle bodyLarge(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 16, 
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: Theme.of(context).colorScheme.onSurface,
      );

  
  static TextStyle bodyMedium(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Theme.of(context).colorScheme.onSurface,
      );

  
  
  static TextStyle label(BuildContext context) => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600, 
    letterSpacing: 1.2,
    color: Theme.of(context).colorScheme.onSurface,
  );

  
  static TextStyle caption(BuildContext context) => GoogleFonts.plusJakartaSans(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.lightTextMuted,
  );

  
  static TextStyle defaultReading(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 1.7,
        color: Theme.of(context).colorScheme.onSurface,
      );

  
  static TextStyle symbol(BuildContext context) => TextStyle(
    fontSize: 32.sp,
    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
  );

  static TextStyle glyph(BuildContext context) => GoogleFonts.plusJakartaSans(
    fontSize: 32.sp,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle readerPrefernce(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 20.sp,
        color: Theme.of(context).colorScheme.onSurface,
      );
}
