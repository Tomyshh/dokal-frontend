import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
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
        backgroundColor: Colors.transparent,
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
                  _AccountHeroCard(
                    title: l10n.accountTaglineTitle,
                    subtitle: l10n.accountTaglineSubtitle,
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  _SectionHeader(title: l10n.accountPersonalInfoSection),
                  SizedBox(height: AppSpacing.sm.h),
                  _MenuTile(
                    icon: Icons.person_rounded,
                    title: l10n.accountMyProfile,
                    onTap: () => context.push('/account/profile'),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  _MenuTile(
                    icon: Icons.group_rounded,
                    title: l10n.accountMyRelatives,
                    onTap: () => context.push('/account/relatives'),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  _SectionHeader(title: l10n.accountSectionTitle),
                  SizedBox(height: AppSpacing.sm.h),
                  _MenuTile(
                    icon: Icons.lock_rounded,
                    title: l10n.securityTitle,
                    onTap: () => context.push('/account/security'),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  _MenuTile(
                    icon: Icons.payments_rounded,
                    title: l10n.paymentTitle,
                    onTap: () => context.push('/account/payment'),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  _MenuTile(
                    icon: Icons.tune_rounded,
                    title: l10n.commonSettings,
                    onTap: () => context.push('/account/settings'),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  _MenuTile(
                    icon: Icons.privacy_tip_rounded,
                    title: l10n.privacyTitle,
                    onTap: () => context.push('/account/privacy'),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  _MenuTile(
                    icon: Icons.logout_rounded,
                    title: l10n.authLogout,
                    showChevron: false,
                    tone: _MenuTileTone.danger,
                    onTap: () => showLogoutConfirmDialog(context),
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

class _AccountHeroCard extends StatelessWidget {
  const _AccountHeroCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.xxl.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandGradientStart,
            AppColors.brandGradientEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 26.r,
            offset: Offset(0, 14.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.xxl.r),
        child: Stack(
          children: [
            Positioned(
              right: -34.r,
              top: -34.r,
              child: Container(
                width: 120.r,
                height: 120.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.10),
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
                  color: AppColors.brandGradientHighlight.withValues(alpha: 0.18),
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
                        width: 1.r,
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.86),
                                height: 1.25,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showChevron = true,
    this.tone = _MenuTileTone.neutral,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showChevron;
  final _MenuTileTone tone;

  @override
  Widget build(BuildContext context) {
    final Color accentColor = switch (tone) {
      _MenuTileTone.danger => AppColors.error,
      _MenuTileTone.neutral => AppColors.primary,
    };

    return DokalCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadii.md.r),
            ),
            child: Icon(icon, size: 18.sp, color: accentColor),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: tone == _MenuTileTone.danger
                        ? AppColors.textPrimary
                        : AppColors.textPrimary,
                  ),
            ),
          ),
          if (showChevron)
            Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadii.pill.r),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 18.sp,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

enum _MenuTileTone { neutral, danger }
