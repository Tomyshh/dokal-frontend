import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';

Future<T?> showDokalModal<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    builder: (context) => SafeArea(
      child: Container(
        margin: EdgeInsets.all(AppSpacing.md.r),
        padding: EdgeInsets.all(AppSpacing.lg.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.xl.r),
          border: Border.all(color: AppColors.outline, width: 1.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 20.r,
              offset: Offset(0, 12.h),
            ),
          ],
        ),
        child: child,
      ),
    ),
  );
}
