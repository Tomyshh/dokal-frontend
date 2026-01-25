import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';

/// Loader shimmer compact.
class DokalLoader extends StatelessWidget {
  const DokalLoader({super.key, this.lines = 3});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Column(
        children: List.generate(lines, (i) {
          final w = i == lines - 1 ? 0.55 : 1.0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: FractionallySizedBox(
              widthFactor: w,
              alignment: Alignment.centerLeft,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

