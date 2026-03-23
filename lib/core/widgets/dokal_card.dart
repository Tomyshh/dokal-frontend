import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_shadows.dart';
import '../constants/app_spacing.dart';

/// Variante de style pour [DokalCard].
enum DokalCardVariant {
  /// Carte avec bordure subtile et ombre légère (défaut).
  elevated,

  /// Carte avec bordure visible, sans ombre.
  outlined,

  /// Carte avec fond coloré léger, sans bordure ni ombre.
  filled,
}

/// Carte moderne Dokal avec variantes.
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
    this.variant = DokalCardVariant.elevated,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final Color? shadowColor;
  final bool showShadow;
  final DokalCardVariant variant;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(AppRadii.xl.r);
    final effectivePadding = padding ?? EdgeInsets.all(AppSpacing.lg.r);

    final Color effectiveColor;
    final Border? effectiveBorder;
    final List<BoxShadow> effectiveShadow;

    switch (variant) {
      case DokalCardVariant.elevated:
        effectiveColor = color ?? AppColors.surface;
        effectiveBorder = Border.all(
          color: borderColor ?? AppColors.outlineSoft,
          width: 1,
        );
        effectiveShadow = showShadow ? AppShadows.sm : AppShadows.none;
      case DokalCardVariant.outlined:
        effectiveColor = color ?? AppColors.surface;
        effectiveBorder = Border.all(
          color: borderColor ?? AppColors.outline,
          width: 1,
        );
        effectiveShadow = AppShadows.none;
      case DokalCardVariant.filled:
        effectiveColor = color ?? AppColors.surfaceVariant;
        effectiveBorder = null;
        effectiveShadow = AppShadows.none;
    }

    final cardContent = Container(
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveRadius,
        border: effectiveBorder,
        boxShadow: effectiveShadow,
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
