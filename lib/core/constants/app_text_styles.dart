import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

/// Catalogue typographique centralisé Dokal.
///
/// Chaque style est une méthode statique qui renvoie un [TextStyle]
/// déjà dimensionné via ScreenUtil (.sp).
///
/// Usage : `Text('Hello', style: AppTextStyles.headingLg())`
class AppTextStyles {
  const AppTextStyles._();

  // ── Headings ───────────────────────────────────────────────────────────

  /// 28sp · w800 · tight tracking — pages de titres, splash
  static TextStyle headingXl({Color? color}) => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.15,
        color: color ?? AppColors.textPrimary,
      );

  /// 24sp · w800 — titres de sections principales
  static TextStyle headingLg({Color? color}) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        height: 1.2,
        color: color ?? AppColors.textPrimary,
      );

  /// 20sp · w700 — titres de cartes / modals
  static TextStyle headingMd({Color? color}) => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.25,
        color: color ?? AppColors.textPrimary,
      );

  /// 17sp · w700 — sous-titres importants
  static TextStyle headingSm({Color? color}) => TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
        height: 1.3,
        color: color ?? AppColors.textPrimary,
      );

  // ── Titles ─────────────────────────────────────────────────────────────

  /// 16sp · w700 — titres de sections dans une page
  static TextStyle titleLg({Color? color}) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color ?? AppColors.textPrimary,
      );

  /// 15sp · w600 — titres de listes, noms de praticiens
  static TextStyle titleMd({Color? color}) => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color ?? AppColors.textPrimary,
      );

  /// 14sp · w600 — titres secondaires
  static TextStyle titleSm({Color? color}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: color ?? AppColors.textPrimary,
      );

  // ── Body ───────────────────────────────────────────────────────────────

  /// 15sp · w400 — texte principal
  static TextStyle bodyLg({Color? color}) => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: color ?? AppColors.textPrimary,
      );

  /// 14sp · w400 — texte courant
  static TextStyle bodyMd({Color? color}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: color ?? AppColors.textSecondary,
      );

  /// 13sp · w400 — texte secondaire, descriptions
  static TextStyle bodySm({Color? color}) => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color ?? AppColors.textSecondary,
      );

  /// 12sp · w400 — texte tertiaire, captions
  static TextStyle bodyXs({Color? color}) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: color ?? AppColors.textTertiary,
      );

  // ── Labels ─────────────────────────────────────────────────────────────

  /// 14sp · w700 — labels de boutons, actions
  static TextStyle labelLg({Color? color}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color ?? AppColors.textPrimary,
      );

  /// 13sp · w600 — labels de boutons compacts
  static TextStyle labelMd({Color? color}) => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color ?? AppColors.textPrimary,
      );

  /// 12sp · w600 — labels de chips, badges
  static TextStyle labelSm({Color? color}) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color ?? AppColors.textSecondary,
      );

  /// 11sp · w600 — micro-labels, timestamps
  static TextStyle labelXs({Color? color}) => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color ?? AppColors.textTertiary,
      );

  // ── Overline / Caption ─────────────────────────────────────────────────

  /// 11sp · w700 · uppercase tracking — en-tête de sections
  static TextStyle overline({Color? color}) => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        height: 1.2,
        color: color ?? AppColors.textSecondary,
      );
}
