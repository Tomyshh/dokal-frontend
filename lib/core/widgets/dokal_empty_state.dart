import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// État vide moderne avec icône, titre et sous-titre.
class DokalEmptyState extends StatelessWidget {
  const DokalEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.inbox_rounded,
    this.action,
    this.maxWidth,
    this.actionFullWidth = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? action;
  final double? maxWidth;
  final bool actionFullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveMaxWidth = (maxWidth ?? 420).w;

    final actionWidget = action == null
        ? null
        : (actionFullWidth ? SizedBox(width: double.infinity, child: action!) : action!);

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl.w,
            vertical: AppSpacing.xxxl.h,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: AppColors.outline),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 20.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64.r,
                      height: 64.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.18),
                            AppColors.primary.withValues(alpha: 0.06),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          width: 1.r,
                        ),
                      ),
                      child: Icon(icon, color: AppColors.primary, size: 26.sp),
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    if (actionWidget != null) ...[
                      SizedBox(height: AppSpacing.lg.h),
                      actionWidget,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
