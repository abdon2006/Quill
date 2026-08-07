import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Backgrounds ──────────────────────────────
  static const Color lightBgPrimary = Color(0xFFF5F0E8);
  static const Color lightBgSurface = Color(0xFFFFFFFF);
  static const Color lightBgSurfaceAlt = Color(0xFFEDE8DF);

  // ── Accent ───────────────────────────────────
  static const Color lightAccentPrimary = Color(0xFF8B3A2A);
  static const Color lightAccentMedium = Color(0xFFC4614A);
  static const Color lightAccentMuted = Color(0xFFE8C4B8);

  // ── Text ─────────────────────────────────────
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color lightTextMuted = Color(0xFFA0A0A0);

  // ── Status ───────────────────────────────────
  static const Color lightGreen = Color(0xFF3D5A3E);
  static const Color lightGreenMuted = Color(0xFF8FAF8F);
  static const Color lightGold = Color(0xFFD4A017);
  static const Color lightError = Color(0xFFB00020);

  // ── Dark Mode ────────────────────────────────
  static const Color darkBgPrimary = Color(0xFF171415);
  static const Color darkBgSurface = Color(0xFF231F20);
  static const Color darkBgSurfaceAlt = Color(0xFF30292B);
  static const Color darkTextPrimary = Color(0xFFF7F4EF);
  static const Color darkTextSecondary = Color(0xFFC8C1BC);
  static const Color darkTextMuted = Color(0xFF9C948F);

  static const Color darkAccentPrimary = Color(0xFFC4614A);
  static const Color darkAccentMedium = Color(0xFFD98A72);
  static const Color darkAccentMuted = Color(0xFF5A403B);

  static const Color darkSuccess = Color(0xFF5D8A63);
  static const Color darkGold = Color(0xFFE0B84A);
  static const Color darkError = Color(0xFFCF6679);

  // ── Sentiment Glow ───────────────────────────
  static const Color glowJoy = Color(0xFFFFD166);
  static const Color glowSadness = Color(0xFF4A90D9);
  static const Color glowTension = Color(0xFFEF476F);
  static const Color glowCalm = Color(0xFF06D6A0);
  static const Color glowMystery = Color(0xFFB56BF7);
}
