import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_text_styles.dart';

/// Variantes sémantiques pour le chip de statut.
enum DokalStatusChipVariant { success, warning, error, info, neutral }

/// Chip de statut réutilisable (confirmé, annulé, en attente, etc.).
///
/// Utilisé dans AppointmentCard, MessagesListPage, PractitionerProfile, etc.
class DokalStatusChip extends StatelessWidget {
  const DokalStatusChip({
    super.key,
    required this.label,
    this.variant = DokalStatusChipVariant.neutral,
    this.icon,
  });

  final String label;
  final DokalStatusChipVariant variant;
  final IconData? icon;

  Color get _backgroundColor => switch (variant) {
        DokalStatusChipVariant.success => AppColors.successLight,
        DokalStatusChipVariant.warning => AppColors.warningLight,
        DokalStatusChipVariant.error => AppColors.errorLight,
        DokalStatusChipVariant.info => AppColors.infoLight,
        DokalStatusChipVariant.neutral => AppColors.surfaceVariant,
      };

  Color get _foregroundColor => switch (variant) {
        DokalStatusChipVariant.success => AppColors.success,
        DokalStatusChipVariant.warning => AppColors.warning,
        DokalStatusChipVariant.error => AppColors.error,
        DokalStatusChipVariant.info => AppColors.info,
        DokalStatusChipVariant.neutral => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppRadii.sm.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.sp, color: _foregroundColor),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: AppTextStyles.labelXs(color: _foregroundColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
