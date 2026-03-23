import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_shadows.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Variante de style du tile.
enum DokalListTileTone { neutral, danger }

/// Tile de menu réutilisable avec icône, titre, sous-titre et chevron.
///
/// Utilisé dans Account, Settings, Security, etc.
class DokalListTile extends StatelessWidget {
  const DokalListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.showChevron = true,
    this.tone = DokalListTileTone.neutral,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showChevron;
  final DokalListTileTone tone;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final accentColor = iconColor ??
        switch (tone) {
          DokalListTileTone.danger => AppColors.error,
          DokalListTileTone.neutral => AppColors.primary,
        };

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.xl.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.xl.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: AppSpacing.sm.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.xl.r),
            border: Border.all(color: AppColors.outlineSoft),
            boxShadow: AppShadows.xs,
          ),
          child: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadii.lg.r),
                ),
                child: Icon(icon, size: 20.sp, color: accentColor),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleSm(),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodyXs(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: AppSpacing.xs.w),
                trailing!,
              ],
              if (showChevron) ...[
                SizedBox(width: AppSpacing.xs.w),
                Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadii.pill.r),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Icon(
                      isRtl
                          ? Icons.chevron_left_rounded
                          : Icons.chevron_right_rounded,
                      size: 18.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
