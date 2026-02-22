import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../utils/format_appointment_date.dart';
import '../constants/app_spacing.dart';

/// Carte de rendez-vous moderne et épurée.
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isPast
                  ? AppColors.outline.withValues(alpha: 0.3)
                  : AppColors.primary.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.04),
                blurRadius: 16.r,
                offset: Offset(0, 4.h),
              ),
              BoxShadow(
                color: isPast
                    ? Colors.transparent
                    : AppColors.primary.withValues(alpha: 0.04),
                blurRadius: 20.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bande d'accent verticale
                Container(
                  width: 4.w,
                  decoration: BoxDecoration(
                    gradient: isPast
                        ? null
                        : const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.brandGradientStart,
                              AppColors.brandGradientEnd,
                            ],
                          ),
                    color: isPast
                        ? AppColors.textSecondary.withValues(alpha: 0.2)
                        : null,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ligne date + heure + trailing
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14.sp,
                              color: isPast
                                  ? AppColors.textSecondary
                                  : AppColors.primary,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                formatAppointmentDateLabel(context, dateLabel),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isPast
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: isPast
                                    ? AppColors.textSecondary.withValues(alpha: 0.08)
                                    : AppColors.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                timeLabel,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: isPast
                                      ? AppColors.textSecondary
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                            if (trailing != null) ...[
                              SizedBox(width: 8.w),
                              trailing!,
                            ],
                          ],
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        // Praticien
                        Row(
                          children: [
                            Container(
                              width: 44.r,
                              height: 44.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  width: 1.5.r,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.08),
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
                                    practitionerName,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      specialty,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20.sp,
                              color: AppColors.textSecondary.withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                        if (reason.isNotEmpty) ...[
                          SizedBox(height: AppSpacing.sm.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.medical_information_outlined,
                                size: 14.sp,
                                color: AppColors.accent.withValues(alpha: 0.8),
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  reason,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                    height: 1.35,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
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
            AppColors.brandGradientStart,
            AppColors.brandGradientEnd,
          ],
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
