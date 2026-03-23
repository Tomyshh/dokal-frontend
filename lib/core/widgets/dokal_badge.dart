import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

/// Badge numérique réutilisable (messages non lus, notifications, etc.).
class DokalBadge extends StatelessWidget {
  const DokalBadge({
    super.key,
    required this.count,
    this.color,
    this.textColor,
    this.size,
  });

  final int count;
  final Color? color;
  final Color? textColor;

  /// Diamètre du badge. Par défaut 18.
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    final effectiveSize = (size ?? 18).r;
    final effectiveColor = color ?? AppColors.primary;
    final effectiveTextColor = textColor ?? Colors.white;
    final displayText = count > 99 ? '99+' : count.toString();

    return Container(
      constraints: BoxConstraints(
        minWidth: effectiveSize,
        minHeight: effectiveSize,
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(effectiveSize / 2),
      ),
      alignment: Alignment.center,
      child: Text(
        displayText,
        style: TextStyle(
          color: effectiveTextColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
