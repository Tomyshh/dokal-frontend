import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Overlay plein écran avec opacité et loader moderne pendant la déconnexion.
class LogoutOverlay extends StatelessWidget {
  const LogoutOverlay({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xl.w,
              vertical: AppSpacing.xl.h,
            ),
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 44.r,
                  height: 44.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  message,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
