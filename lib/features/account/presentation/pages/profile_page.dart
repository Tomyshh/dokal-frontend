import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (prev, next) =>
            prev.deleteAccountStatus != next.deleteAccountStatus,
        listener: (context, state) async {
          if (state.deleteAccountStatus == DeleteAccountStatus.failure) {
            final msg = state.deleteAccountError ?? l10n.errorUnableToDeleteAccount;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          }

          if (state.deleteAccountStatus == DeleteAccountStatus.success) {
            await Supabase.instance.client.auth.signOut();
            if (!context.mounted) return;
            context.read<AuthBloc>().add(const AuthRefreshRequested());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.profileAccountDeletedSnack)),
            );
            context.go('/home');
          }
        },
        builder: (context, state) {
          final UserProfile? p = state.profile;
          final isDeleting =
              state.deleteAccountStatus == DeleteAccountStatus.loading;

          final body = state.status == ProfileStatus.loading
              ? Padding(
                  padding: EdgeInsets.all(AppSpacing.lg.r),
                  child: const DokalLoader(lines: 5),
                )
              : state.status == ProfileStatus.failure
              ? DokalEmptyState(
                  title: l10n.profileUnavailableTitle,
                  subtitle: state.error ?? l10n.commonTryAgainLater,
                  icon: Icons.person_off_rounded,
                )
              : p == null
              ? DokalEmptyState(
                  title: l10n.profileUnavailableTitle,
                  subtitle: l10n.profileUnavailableSubtitle,
                  icon: Icons.person_off_rounded,
                )
              : ListView(
                  padding: EdgeInsets.all(AppSpacing.lg.r),
                  children: [
                    _ProfileSection(
                      title: l10n.profileIdentitySection,
                      children: [
                        _InfoRow(label: l10n.commonName, value: p.fullName),
                        _InfoRow(label: l10n.commonEmail, value: p.email),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    _ProfileSection(
                      title: l10n.commonAddress,
                      children: [
                        _InfoRow(label: l10n.commonCity, value: p.city),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    _ProfileSection(
                      title: l10n.profileMedicalInfoSection,
                      children: [
                        _InfoRow(label: l10n.profileBloodType, value: '—'),
                        _InfoRow(label: l10n.profileHeight, value: '—'),
                        _InfoRow(label: l10n.profileWeight, value: '—'),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xl.h),
                    _DangerZoneCard(
                      onDelete: isDeleting
                          ? null
                          : () => _confirmDeleteAccount(context),
                    ),
                    SizedBox(height: AppSpacing.md.h),
                  ],
                );

          return Scaffold(
            appBar: DokalAppBar(
              title: l10n.profileTitle,
              showBackButton: !isDeleting,
            ),
            body: PopScope(
              canPop: !isDeleting,
              child: SafeArea(
                child: Stack(
                  children: [
                    body,
                    if (isDeleting) const _OverlayDeletingAccount(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.profileDeleteAccountDialogTitle),
          content: Text(l10n.profileDeleteAccountDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.profileDeleteAccountConfirm),
            ),
          ],
        );
      },
    );
    if (ok == true && context.mounted) {
      context.read<ProfileCubit>().deleteAccount();
    }
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DokalCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg.w,
              AppSpacing.md.h,
              AppSpacing.lg.w,
              AppSpacing.sm.h,
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...children,
          SizedBox(height: AppSpacing.sm.h),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.sm.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Flexible(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _DangerZoneCard extends StatelessWidget {
  const _DangerZoneCard({required this.onDelete});

  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DokalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileDangerZoneTitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            l10n.profileDeleteAccountHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: onDelete,
              child: Text(l10n.profileDeleteAccountButton),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlayDeletingAccount extends StatelessWidget {
  const _OverlayDeletingAccount();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Positioned.fill(
      child: AbsorbPointer(
        child: Stack(
          children: [
            ColoredBox(color: Colors.black.withValues(alpha: 0.25)),
            Center(
              child: DokalCard(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg.r),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: AppSpacing.md.w),
                      Flexible(
                        child: Text(
                          l10n.profileDeleteAccountLoading,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
