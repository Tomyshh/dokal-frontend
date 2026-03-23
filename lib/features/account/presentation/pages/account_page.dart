import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_animations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_fade_in.dart';
import '../../../../core/widgets/dokal_list_tile.dart';
import '../../../../core/widgets/logout_overlay.dart';
import '../../../../l10n/l10n.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/utils/logout_confirm_dialog.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          prev.status == AuthStatus.loggingOut &&
          curr.status == AuthStatus.unauthenticated,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.authLogoutSuccess)),
        );
        context.go('/home');
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: DokalAppBar(
          title: l10n.accountTitle,
          showBackButton: false,
          centerTitle: false,
        ),
        body: Stack(
          children: [
            SafeArea(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg.w,
                  AppSpacing.lg.h,
                  AppSpacing.lg.w,
                  AppSpacing.lg.h + 100.h,
                ),
                children: [
                  DokalFadeIn(
                    child: _AccountHeroCard(
                      title: l10n.accountTaglineTitle,
                      subtitle: l10n.accountTaglineSubtitle,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl.h),

                  // ── Personal info ────────────────────────────────
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(1),
                    child: _SectionHeader(
                      title: l10n.accountPersonalInfoSection,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(2),
                    child: DokalListTile(
                      icon: Icons.person_rounded,
                      title: l10n.accountMyProfile,
                      onTap: () => context.push('/account/profile'),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(3),
                    child: DokalListTile(
                      icon: Icons.group_rounded,
                      title: l10n.accountMyRelatives,
                      onTap: () => context.push('/account/relatives'),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl.h),

                  // ── Settings ─────────────────────────────────────
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(4),
                    child: _SectionHeader(title: l10n.accountSectionTitle),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(5),
                    child: DokalListTile(
                      icon: Icons.lock_rounded,
                      title: l10n.securityTitle,
                      onTap: () => context.push('/account/security'),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(6),
                    child: DokalListTile(
                      icon: Icons.tune_rounded,
                      title: l10n.commonSettings,
                      onTap: () => context.push('/account/settings'),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(7),
                    child: DokalListTile(
                      icon: Icons.privacy_tip_rounded,
                      title: l10n.privacyTitle,
                      onTap: () => context.push('/account/privacy'),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl.h),

                  // ── Logout ───────────────────────────────────────
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(8),
                    child: DokalListTile(
                      icon: Icons.logout_rounded,
                      title: l10n.authLogout,
                      showChevron: false,
                      tone: DokalListTileTone.danger,
                      onTap: () => showLogoutConfirmDialog(context),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (prev, curr) => prev.status != curr.status,
              builder: (context, state) {
                if (state.status != AuthStatus.loggingOut) {
                  return const SizedBox.shrink();
                }
                return LogoutOverlay(message: l10n.authLoggingOut);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HERO CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _AccountHeroCard extends StatelessWidget {
  const _AccountHeroCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.xxl.r),
        gradient: AppColors.brandGradient,
        boxShadow: AppShadows.primaryGlow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.xxl.r),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -34.r,
              top: -34.r,
              child: Container(
                width: 120.r,
                height: 120.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              left: -22.r,
              bottom: -22.r,
              child: Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brandGradientHighlight
                      .withValues(alpha: 0.15),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg.r),
              child: Row(
                children: [
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(AppRadii.lg.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Icon(
                      Icons.shield_rounded,
                      size: 22.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.titleMd(
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          subtitle,
                          style: AppTextStyles.bodyXs(
                            color: Colors.white.withValues(alpha: 0.86),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.overline(),
    );
  }
}
