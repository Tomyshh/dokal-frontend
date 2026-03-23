import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_shadows.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../utils/address_actions.dart';
import '../utils/format_appointment_date.dart';
import '../../l10n/l10n.dart';

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
    this.address,
    this.isPast = false,
    this.status,
  });

  final String dateLabel;
  final String timeLabel;
  final String practitionerName;
  final String specialty;
  final String reason;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String? avatarUrl;
  final String? address;
  final bool isPast;
  final String? status;

  String? _statusLabel(BuildContext context) {
    if (status == null) return null;
    return context.l10n.patientAppointmentStatusLabel(status!);
  }

  String _getInitials() {
    final name = practitionerName
        .replaceAll('ד"ר ', '')
        .replaceAll('Dr. ', '')
        .trim();
    if (name.isEmpty) return '?';

    final parts = name.split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return parts[0][0];
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.xl.r),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.xl.r),
            border: Border.all(
              color: isPast
                  ? AppColors.outline.withValues(alpha: 0.5)
                  : AppColors.primary.withValues(alpha: 0.08),
            ),
            boxShadow: isPast ? AppShadows.xs : AppShadows.sm,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.xl.r),
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
                          : AppColors.brandGradient,
                      color: isPast
                          ? AppColors.textTertiary.withValues(alpha: 0.3)
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Date + heure + trailing ──────────────────
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14.sp,
                                color: isPast
                                    ? AppColors.textTertiary
                                    : AppColors.primary,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  formatAppointmentDateLabel(context, dateLabel),
                                  style: AppTextStyles.labelMd(
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
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isPast
                                      ? AppColors.surfaceVariant
                                      : AppColors.primarySurface,
                                  borderRadius:
                                      BorderRadius.circular(AppRadii.sm.r),
                                ),
                                child: Text(
                                  timeLabel,
                                  style: AppTextStyles.labelSm(
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
                          // ── Praticien ───────────────────────────────
                          Row(
                            children: [
                              _PractitionerAvatar(
                                avatarUrl: avatarUrl,
                                initials: _getInitials(),
                                isPast: isPast,
                              ),
                              SizedBox(width: AppSpacing.md.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            practitionerName,
                                            style: AppTextStyles.titleMd(
                                              color: AppColors.textPrimary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (_statusLabel(context) != null) ...[
                                          SizedBox(width: 8.w),
                                          _StatusChip(
                                            label: _statusLabel(context)!,
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primarySurface,
                                        borderRadius: BorderRadius.circular(
                                          AppRadii.xs.r,
                                        ),
                                      ),
                                      child: Text(
                                        specialty,
                                        style: AppTextStyles.labelXs(
                                          color: AppColors.primary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Icon(
                                  isRtl
                                      ? Icons.chevron_left_rounded
                                      : Icons.chevron_right_rounded,
                                  size: 20.sp,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                          // ── Reason ──────────────────────────────────
                          if (reason.isNotEmpty) ...[
                            SizedBox(height: AppSpacing.sm.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.medical_information_outlined,
                                  size: 14.sp,
                                  color: AppColors.accent.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    reason,
                                    style: AppTextStyles.bodyXs(
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          // ── Address ─────────────────────────────────
                          if (address != null && address!.isNotEmpty) ...[
                            SizedBox(height: AppSpacing.sm.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14.sp,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => openAddressInMaps(address!),
                                    child: Text(
                                      address!,
                                      style: AppTextStyles.bodyXs(
                                        color: AppColors.primary,
                                      ).copyWith(
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primary
                                            .withValues(alpha: 0.4),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                GestureDetector(
                                  onTap: () => copyAddress(context, address!),
                                  child: Icon(
                                    Icons.copy_rounded,
                                    size: 14.sp,
                                    color: AppColors.textTertiary,
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

class _PractitionerAvatar extends StatelessWidget {
  const _PractitionerAvatar({
    required this.avatarUrl,
    required this.initials,
    required this.isPast,
  });

  final String? avatarUrl;
  final String initials;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isPast
              ? AppColors.outline
              : AppColors.primary.withValues(alpha: 0.15),
          width: 1.5.r,
        ),
        boxShadow: isPast
            ? AppShadows.none
            : [
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
                    _AvatarPlaceholder(initials: initials),
                errorWidget: (context, url, error) =>
                    _AvatarPlaceholder(initials: initials),
              )
            : _AvatarPlaceholder(initials: initials),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppRadii.sm.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelXs(color: AppColors.error),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
        gradient: AppColors.brandGradient,
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
