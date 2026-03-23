import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

/// Niveaux d'ombre standardisés pour toute l'application.
///
/// Chaque niveau correspond à une élévation visuelle croissante.
/// Usage : `boxShadow: AppShadows.sm`
class AppShadows {
  const AppShadows._();

  /// Ombre très subtile – cartes plates, séparateurs visuels
  static List<BoxShadow> get xs => [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 4.r,
          offset: Offset(0, 1.h),
        ),
      ];

  /// Ombre légère – cartes au repos
  static List<BoxShadow> get sm => [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 8.r,
          offset: Offset(0, 2.h),
        ),
      ];

  /// Ombre moyenne – cartes en hover / focus
  static List<BoxShadow> get md => [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 16.r,
          offset: Offset(0, 4.h),
        ),
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 6.r,
          offset: Offset(0, 2.h),
        ),
      ];

  /// Ombre forte – modals, bottom sheets, FABs
  static List<BoxShadow> get lg => [
        BoxShadow(
          color: AppColors.shadowMedium,
          blurRadius: 24.r,
          offset: Offset(0, 8.h),
        ),
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 8.r,
          offset: Offset(0, 4.h),
        ),
      ];

  /// Ombre très forte – éléments flottants, drawers
  static List<BoxShadow> get xl => [
        BoxShadow(
          color: AppColors.shadowMedium,
          blurRadius: 32.r,
          offset: Offset(0, 12.h),
        ),
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 12.r,
          offset: Offset(0, 6.h),
        ),
      ];

  /// Ombre teintée primary – cartes d'accent / hero cards
  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.20),
          blurRadius: 24.r,
          offset: Offset(0, 10.h),
        ),
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.08),
          blurRadius: 8.r,
          offset: Offset(0, 4.h),
        ),
      ];

  /// Ombre pour la bottom navigation bar
  static List<BoxShadow> get navbar => [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 16.r,
          offset: Offset(0, -4.h),
        ),
      ];

  /// Pas d'ombre
  static const List<BoxShadow> none = [];
}
