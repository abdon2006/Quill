import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // ── Display (للعناوين الضخمة والترحيب في بداية الشاشات) ──
  // الاستخدام: ترحيب الهوم (Good Morning) أو أرقام ضخمة.
  static TextStyle displayLarge(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // الاستخدام: عناوين الشاشات الأساسية لو مش هنستخدم الـ Large.
  static TextStyle displayMedium(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // ── Headings (لعناوين السكاشن البارزة وأسماء الكتب) ──
  // الاستخدام: SectionHeader (زي Your Library, Popular Books)
  static TextStyle heading1(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // الاستخدام: عناوين الكتب في الكروت (Continue Reading أو Grid)
  static TextStyle heading2(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600, // خليتها 600 عشان تبرز كعنوان
        color: Theme.of(context).colorScheme.onSurface,
      );

  // ── Body (للنصوص العادية، الوصف، والتفاصيل الثانوية) ──
  // الاستخدام: فقرات القراءة، وصف الكتاب (Synopsis)
  static TextStyle bodyLarge(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 16, // الستاندرد المريح للعين
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // الاستخدام: أسماء الكُتّاب (Authors)، العناوين الفرعية (Subtitles)
  static TextStyle bodyMedium(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // ── Labels & Captions (للبادجات، التواريخ، والكلمات الدليلية) ──
  // الاستخدام: التاريخ، كلمة CURRENT BOOK، أزرار See All (غالباً بتبقى كابيتال)
  static TextStyle label(BuildContext context) => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600, // خليتها 600 عشان تبان رغم صغرها
    letterSpacing: 1.2,
    color: Theme.of(context).colorScheme.onSurface,
  );

  // الاستخدام: التلميحات الصغيرة جداً، نسب التقدم (64%)
  static TextStyle caption(BuildContext context) => GoogleFonts.plusJakartaSans(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.lightTextMuted,
  );

  // ── Arabic ───────────────────────────────────
  static TextStyle arabicBody(BuildContext context) =>
      GoogleFonts.notoSansArabic(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.8,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle arabicHeading(BuildContext context) =>
      GoogleFonts.notoSansArabic(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      );
}
