import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // ── Primary palette ──────────────────────────────────────────────────
  static const Color primary = Color(0xFF0B8F78);
  static const Color primaryLight = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF005044);
  static const Color primaryLightBackground = Color(0xFFE7F7F0);
  static const Color primarySurface = Color(0xFFF0FDF9);

  // Brand gradient (bannières / cartes promo)
  static const Color brandGradientStart = Color(0xFF0B8F78);
  static const Color brandGradientEnd = Color(0xFF34D399);
  static const Color brandGradientHighlight = Color(0xFF6EE7B7);

  /// Gradient linéaire de marque standard.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandGradientStart, brandGradientEnd],
  );

  // ── Semantic colours ─────────────────────────────────────────────────
  static const Color accent = Color(0xFF10B981);

  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ── Neutrals ─────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF7FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceHover = Color(0xFFF8FAFC);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFE2E8F0);
  static const Color outlineSoft = Color(0xFFF0F4F8);
  static const Color divider = Color(0xFFE2E8F0);

  // ── Shadows ──────────────────────────────────────────────────────────
  static const Color shadow = Color(0x0D000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowHeavy = Color(0x33000000);

  // ── Misc ─────────────────────────────────────────────────────────────
  /// Indicateur de localisation (ville, distance) – jaune/orange discret
  static const Color locationIndicator = Color(0xFFE8A54B);
  static const Color locationIndicatorLight = Color(0xFFFFF4E0);

  /// Overlay pour modals / drawers
  static const Color scrim = Color(0x80000000);
}
