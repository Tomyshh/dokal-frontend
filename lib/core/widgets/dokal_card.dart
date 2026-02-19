import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';

/// Carte moderne Dokal avec styles compacts.
class DokalCard extends StatelessWidget {
  const DokalCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.shadowColor,
    this.showShadow = true,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final Color? shadowColor;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(AppRadii.lg.r);
    final effectiveColor = color ?? AppColors.surface;
    final effectiveBorderColor = borderColor ?? AppColors.outlineSoft;
    final effectivePadding = padding ?? EdgeInsets.all(AppSpacing.lg.r);
    final effectiveShadow = shadowColor ?? AppColors.shadow;

    final cardContent = Container(
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveRadius,
        border: Border.all(color: effectiveBorderColor, width: 1.w),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: effectiveShadow,
                  blurRadius: 18.r,
                  offset: Offset(0, 8.h),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: Padding(padding: effectivePadding, child: child),
      ),
    );

    if (onTap == null) return cardContent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: effectiveRadius,
        onTap: onTap,
        child: cardContent,
      ),
    );
  }
}
