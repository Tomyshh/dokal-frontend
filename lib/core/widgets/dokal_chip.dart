import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_text_styles.dart';

class DokalChip extends StatelessWidget {
  const DokalChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.primarySurface : AppColors.surface;
    final border = selected ? AppColors.primary : AppColors.outline;
    final fg = selected ? AppColors.primary : AppColors.textPrimary;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.pill.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadii.pill.r),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18.sp, color: fg),
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: AppTextStyles.labelMd(color: fg),
            ),
          ],
        ),
      ),
    );
  }
}
