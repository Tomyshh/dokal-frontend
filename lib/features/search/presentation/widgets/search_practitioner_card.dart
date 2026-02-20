import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/format_next_availability.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/practitioner_search_result.dart';
import '../../../practitioner/domain/usecases/get_practitioner_slots.dart';

/// Carte praticien pour la page de recherche (design type liste médecin).
class SearchPractitionerCard extends StatelessWidget {
  const SearchPractitionerCard({
    super.key,
    required this.practitioner,
    required this.onTap,
    required this.onBookTap,
  });

  final PractitionerSearchResult practitioner;
  final VoidCallback onTap;
  final VoidCallback onBookTap;

  String _getInitials() {
    final parts = practitioner.name
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

  String _formatPriceLabel() {
    final min = practitioner.priceMinAgorot;
    final max = practitioner.priceMaxAgorot;
    if (min != null && max != null) {
      if (min == max) {
        return '${(min / 100).round()}₪';
      }
      return '${(min / 100).round()}-${(max / 100).round()}₪';
    }
    if (min != null) {
      return '${(min / 100).round()}₪';
    }
    if (max != null) {
      return '${(max / 100).round()}₪';
    }
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.outline, width: 1.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 8.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: ClipOval(
                child: (practitioner.avatarUrl?.trim().isNotEmpty ?? false)
                    ? CachedNetworkImage(
                        imageUrl: practitioner.avatarUrl!.trim(),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _AvatarPlaceholder(
                          initials: _getInitials(),
                        ),
                        errorWidget: (context, url, error) => _AvatarPlaceholder(
                          initials: _getInitials(),
                        ),
                      )
                    : _AvatarPlaceholder(initials: _getInitials()),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            // Infos centrales
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    practitioner.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    practitioner.specialty,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  SizedBox(height: 6.h),
                  // Rating
                  if (practitioner.rating != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16.sp,
                          color: const Color(0xFFF59E0B),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          practitioner.rating!.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        if (practitioner.reviewCount != null) ...[
                          Text(
                            ' (${practitioner.reviewCount})',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 6.h),
                  ],
                  // Prochain créneau
                  if (practitioner.nextAvailabilityLabel.isNotEmpty)
                    _StaticSlotLabel(
                      rawLabel: practitioner.nextAvailabilityLabel,
                    )
                  else
                    _NextSlotLabel(practitionerId: practitioner.id),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),
            // Prix + bouton
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.searchFeesLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _formatPriceLabel(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                ),
                SizedBox(height: 10.h),
                DokalButton.primary(
                  onPressed: onBookTap,
                  compact: true,
                  child: Text(
                    l10n.searchBookNow,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Affiche un créneau déjà connu (depuis la recherche).
class _StaticSlotLabel extends StatelessWidget {
  const _StaticSlotLabel({required this.rawLabel});

  final String rawLabel;

  @override
  Widget build(BuildContext context) {
    final label =
        formatNextAvailabilityLabel(rawLabel, context.l10n);
    return Row(
      children: [
        Icon(
          Icons.schedule_rounded,
          size: 14.sp,
          color: AppColors.accent,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

/// Affiche le prochain créneau (fetch via API si absent).
class _NextSlotLabel extends StatelessWidget {
  const _NextSlotLabel({required this.practitionerId});

  final String practitionerId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchNextSlot(),
      builder: (context, snapshot) {
        final rawLabel = snapshot.data;
        if (rawLabel == null || rawLabel.isEmpty) {
          return const SizedBox.shrink();
        }
        final label =
            formatNextAvailabilityLabel(rawLabel, context.l10n);
        return Row(
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 14.sp,
              color: AppColors.accent,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String> _fetchNextSlot() async {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from.add(const Duration(days: 14));
    final fromStr =
        '${from.year}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}';
    final toStr =
        '${to.year}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}';

    final result = await sl<GetPractitionerSlots>().call(
      practitionerId,
      from: fromStr,
      to: toStr,
    );

    return result.fold(
      (_) => '',
      (slots) {
        if (slots.isEmpty) return '';
        final first = slots.first;
        final date = first['slot_date'] ?? '';
        final start = first['slot_start'] ?? '';
        if (date.isEmpty || start.isEmpty) return '';
        final time = start.length >= 5 ? start.substring(0, 5) : start;
        return '$date $time';
      },
    );
  }
}
