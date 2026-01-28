import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../l10n/l10n.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48.h,
        title: Text(
          l10n.accountTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.lg.r),
          children: [
            DokalCard(
              padding: EdgeInsets.all(AppSpacing.md.r),
              child: Row(
                children: [
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadii.sm.r),
                    ),
                    child: Icon(
                      Icons.shield_rounded,
                      size: 18.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.accountTaglineTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          l10n.accountTaglineSubtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
              onTap: () =>
                  context.read<AuthBloc>().add(const AuthLogoutRequested()),
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
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return DokalCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: AppColors.textSecondary),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleSmall),
          ),
          if (showChevron)
            Icon(
              Icons.chevron_right_rounded,
              size: 18.sp,
              color: AppColors.textSecondary,
            ),
        ],
      ),
    );
  }
}
