import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import 'dokal_card.dart';

/// Carte de rendez-vous compacte et moderne.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.dateLabel,
    required this.timeLabel,
    required this.practitionerName,
    required this.specialty,
    required this.reason,
    this.onTap,
    this.trailing,
    this.avatarUrl,
    this.isPast = false,
  });

  final String dateLabel;
  final String timeLabel;
  final String practitionerName;
  final String specialty;
  final String reason;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String? avatarUrl;
  final bool isPast;

  String _getInitials() {
    final parts = practitionerName
        .replaceAll('ד"ר ', '')
        .replaceAll('Dr. ', '')
        .split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0];
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return DokalCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date/Time row avec couleur
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm.w,
                    vertical: AppSpacing.xs.h,
                  ),
                  decoration: BoxDecoration(
                    color: isPast
                        ? AppColors.textSecondary.withValues(alpha: 0.08)
                        : AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadii.sm.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14.sp,
                        color: isPast ? AppColors.textSecondary : AppColors.accent,
                      ),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          dateLabel,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: isPast
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.schedule_rounded,
                        size: 14.sp,
                        color: isPast ? AppColors.textSecondary : AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        timeLabel,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: isPast
                                  ? AppColors.textSecondary
                                  : AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: AppSpacing.sm.w),
                trailing!,
              ],
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          // Practitioner row avec avatar
          Row(
            children: [
              // Avatar
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: avatarUrl != null
                      ? CachedNetworkImage(
                          imageUrl: avatarUrl!,
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
                      practitionerName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
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
              Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 20.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          // Reason row
          Row(
            children: [
              Icon(
                Icons.medical_services_rounded,
                size: 14.sp,
                color: AppColors.accent,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  reason,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
