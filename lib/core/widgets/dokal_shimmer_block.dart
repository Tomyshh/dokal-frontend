import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';

/// Bloc shimmer réutilisable pour les états de chargement.
///
/// Peut être utilisé seul ou groupé dans un [DokalShimmerGroup].
class DokalShimmerBlock extends StatelessWidget {
  const DokalShimmerBlock({
    super.key,
    required this.height,
    this.width,
    this.borderRadius,
  });

  /// Crée un bloc circulaire (avatar placeholder).
  const DokalShimmerBlock.circle({
    super.key,
    required double size,
  })  : height = size,
        width = size,
        borderRadius = 999;

  final double height;
  final double? width;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(
          (borderRadius ?? AppRadii.sm).r,
        ),
      ),
    );
  }
}

/// Enveloppe shimmer animée pour grouper plusieurs [DokalShimmerBlock].
class DokalShimmerGroup extends StatelessWidget {
  const DokalShimmerGroup({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface.withValues(alpha: 0.9),
      child: child,
    );
  }
}
