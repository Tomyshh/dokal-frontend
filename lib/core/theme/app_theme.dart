import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      secondary: AppColors.accent,
      error: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.outline,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Montserrat',
      splashFactory: InkSparkle.splashFactory,
    );

    final text = base.textTheme;

    return base.copyWith(
      // ── AppBar ─────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 18.sp,
        ),
      ),

      // ── TextTheme ──────────────────────────────────────────────────────
      textTheme: text.copyWith(
        headlineLarge: text.headlineLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          fontSize: 28.sp,
        ),
        headlineMedium: text.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
          fontSize: 24.sp,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          fontSize: 20.sp,
        ),
        titleLarge: text.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 17.sp,
        ),
        titleMedium: text.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 15.sp,
        ),
        titleSmall: text.titleSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
        bodyLarge: text.bodyLarge?.copyWith(
          color: AppColors.textPrimary,
          height: 1.45,
          fontSize: 15.sp,
        ),
        bodyMedium: text.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
          height: 1.45,
          fontSize: 14.sp,
        ),
        bodySmall: text.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          height: 1.4,
          fontSize: 13.sp,
        ),
        labelLarge: text.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
        ),
        labelMedium: text.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: AppColors.textSecondary,
        ),
        labelSmall: text.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
          color: AppColors.textTertiary,
        ),
      ),

      // ── Input ──────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.md.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5.r),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
          borderSide: BorderSide(color: AppColors.error, width: 1.5.r),
        ),
        hintStyle: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 14.sp,
        ),
        labelStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: TextStyle(
          color: AppColors.error,
          fontSize: 12.sp,
        ),
      ),

      // ── Card ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl.r),
          side: const BorderSide(color: AppColors.outlineSoft),
        ),
      ),

      // ── Divider ────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ── BottomSheet ────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        dragHandleColor: AppColors.outline,
        dragHandleSize: Size(40.w, 4.h),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.xxl.r),
          ),
        ),
      ),

      // ── SnackBar ───────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: Colors.white,
          fontSize: 14.sp,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
        ),
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.md.h,
        ),
      ),

      // ── Switch ─────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textTertiary.withValues(alpha: 0.22);
        }),
      ),

      // ── ListTile ───────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        contentPadding: EdgeInsets.zero,
        dense: true,
        minLeadingWidth: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
        ),
      ),

      // ── NavigationBar (Material 3) ─────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        height: 64.h,
        indicatorColor: AppColors.primarySurface,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.primary, size: 22.sp);
          }
          return IconThemeData(color: AppColors.textTertiary, size: 22.sp);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              fontSize: 11.sp,
            );
          }
          return text.labelSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
            fontSize: 11.sp,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      // ── FloatingActionButton ───────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl.r),
        ),
      ),

      // ── Dialog ─────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xxl.r),
        ),
        titleTextStyle: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),

      // ── TabBar ─────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
        ),
        splashBorderRadius: BorderRadius.circular(AppRadii.lg.r),
      ),

      // ── Chip ───────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primaryLightBackground,
        side: const BorderSide(color: AppColors.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      ),
    );
  }
}
