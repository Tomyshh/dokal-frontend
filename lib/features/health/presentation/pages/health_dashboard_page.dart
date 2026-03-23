import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../l10n/l10n.dart';

class HealthDashboardPage extends StatelessWidget {
  const HealthDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg.w,
                  AppSpacing.lg.h,
                  AppSpacing.lg.w,
                  AppSpacing.md.h,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: AppShadows.primaryGlow,
                      ),
                      child: Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.healthTitle,
                            style: AppTextStyles.headingLg(),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            l10n.healthSubtitle,
                            style: AppTextStyles.bodyMd(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Contenu
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: AppSpacing.sm.h),
                  // Carte statut
                  _StatusCard(),
                  SizedBox(height: AppSpacing.xl.h),
                  // Section menu
                  Text(
                    l10n.healthMyFileSectionTitle,
                    style: AppTextStyles.titleLg(color: AppColors.primary),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  _MenuCard(
                    icon: Icons.healing_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    iconBgColor: const Color(0xFFFFFBEB),
                    title: l10n.healthConditionsTitle,
                    subtitle: l10n.healthConditionsSubtitle,
                    onTap: () => context.push('/health/conditions'),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  _MenuCard(
                    icon: Icons.medication_rounded,
                    iconColor: const Color(0xFF10B981),
                    iconBgColor: const Color(0xFFECFDF5),
                    title: l10n.healthMedicationsTitle,
                    subtitle: l10n.healthMedicationsSubtitle,
                    onTap: () => context.push('/health/medications'),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  _MenuCard(
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFEF4444),
                    iconBgColor: const Color(0xFFFEF2F2),
                    title: l10n.healthAllergiesTitle,
                    subtitle: l10n.healthAllergiesSubtitle,
                    onTap: () => context.push('/health/allergies'),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  _MenuCard(
                    icon: Icons.vaccines_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    iconBgColor: const Color(0xFFF5F3FF),
                    title: l10n.healthVaccinationsTitle,
                    subtitle: l10n.healthVaccinationsSubtitle,
                    onTap: () => context.push('/health/vaccinations'),
                  ),
                  SizedBox(height: 100.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLightBackground,
            AppColors.primaryLightBackground.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: AppShadows.sm,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: AppColors.accent,
              size: 28.sp,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.healthUpToDateTitle,
                  style: AppTextStyles.titleLg(),
                ),
                SizedBox(height: 4.h),
                Text(
                  l10n.healthUpToDateSubtitle,
                  style: AppTextStyles.bodySm(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMd(),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm(),
                  ),
                ],
              ),
            ),
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
