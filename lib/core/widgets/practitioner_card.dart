import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import 'dokal_card.dart';

/// Carte de praticien compacte et moderne.
class PractitionerCard extends StatelessWidget {
  const PractitionerCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.address,
    required this.sector,
    required this.nextAvailabilityLabel,
    this.distanceLabel,
    this.avatarUrl,
    this.onTap,
  });

  final String name;
  final String specialty;
  final String address;
  final String sector;
  final String nextAvailabilityLabel;
  final String? distanceLabel;
  final String? avatarUrl;
  final VoidCallback? onTap;

  // Retourne une couleur basée sur la disponibilité
  Color _getAvailabilityColor() {
    if (nextAvailabilityLabel.contains('היום') ||
        nextAvailabilityLabel.toLowerCase().contains('today')) {
      return AppColors.accent;
    } else if (nextAvailabilityLabel.contains('מחר') ||
        nextAvailabilityLabel.toLowerCase().contains('tomorrow')) {
      return const Color(0xFF3B82F6); // Blue
    }
    return AppColors.primary;
  }

  // Génère les initiales à partir du nom
  String _getInitials() {
    final parts = name.replaceAll('ד"ר ', '').replaceAll('Dr. ', '').split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0];
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final availabilityColor = _getAvailabilityColor();
    final bool isAvailableToday =
        nextAvailabilityLabel.contains('היום') ||
        nextAvailabilityLabel.toLowerCase().contains('today');
    final sectorText = sector.trim();
    final availabilityText = nextAvailabilityLabel.trim();
    final hasSector = sectorText.isNotEmpty;
    final hasAvailability = availabilityText.isNotEmpty;

    return DokalCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar avec photo ou initiales
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: (avatarUrl?.trim().isNotEmpty ?? false)
                      ? CachedNetworkImage(
                          imageUrl: avatarUrl!.trim(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              _AvatarPlaceholder(initials: _getInitials()),
                          errorWidget: (context, url, error) =>
                              _AvatarPlaceholder(initials: _getInitials()),
                        )
                      : _AvatarPlaceholder(initials: _getInitials()),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        specialty,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (distanceLabel != null) ...[
                SizedBox(width: AppSpacing.sm.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.near_me_rounded,
                        size: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        distanceLabel!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          // Info row avec icônes colorées
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 14.sp,
                color: const Color(0xFFEF4444), // Red subtle
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  address,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (hasSector || hasAvailability) ...[
            SizedBox(height: AppSpacing.xs.h),
            Row(
              children: [
                if (hasSector) ...[
                  Icon(
                    Icons.health_and_safety_rounded,
                    size: 14.sp,
                    color: AppColors.accent,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      sectorText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                if (!hasSector && hasAvailability) const Spacer(),
                if (hasSector && hasAvailability) const Spacer(),
                if (hasAvailability)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: availabilityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadii.pill.r),
                      border: isAvailableToday
                          ? Border.all(
                              color: availabilityColor.withValues(alpha: 0.3),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isAvailableToday) ...[
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: BoxDecoration(
                              color: availabilityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                        ],
                        Text(
                          availabilityText,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: availabilityColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Placeholder pour l'avatar avec initiales
class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
