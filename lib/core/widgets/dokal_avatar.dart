import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class DokalAvatar extends StatelessWidget {
  const DokalAvatar({
    super.key,
    required this.name,
    this.size = 44,
    this.backgroundColor,
  });

  final String name;
  /// Taille logique (design) ; le widget applique .r et .sp en interne.
  final double size;
  final Color? backgroundColor;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.take(2).toString();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.10),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: (size * 0.34).sp,
        ),
      ),
    );
  }
}
