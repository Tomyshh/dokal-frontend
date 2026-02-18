import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

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
    final bg = selected
        ? AppColors.primary.withValues(alpha: 0.12)
        : AppColors.surface;
    final border = selected ? AppColors.primary : AppColors.outline;
    final fg = selected ? AppColors.primary : AppColors.textPrimary;

    return InkWell(
      borderRadius: BorderRadius.circular(999.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: border, width: 1.r),
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
              style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
