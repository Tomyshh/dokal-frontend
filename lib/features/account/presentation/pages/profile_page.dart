import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../core/widgets/dokal_text_field.dart';
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
            prev.deleteAccountStatus != next.deleteAccountStatus ||
            prev.updateError != next.updateError,
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
          if (state.updateError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.updateError!)),
            );
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
                        _EditableNameRow(
                          label: l10n.commonName,
                          profile: p,
                          onTap: () => _showEditNameDialog(context, p),
                        ),
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

  Future<void> _showEditNameDialog(BuildContext context, UserProfile p) async {
    final l10n = context.l10n;
    final profileCubit = context.read<ProfileCubit>();
    final firstNameController = TextEditingController(
      text: p.firstName ?? p.fullName.split(' ').firstOrNull ?? '',
    );
    final lastNameController = TextEditingController(
      text: p.lastName ??
          (p.fullName.split(' ').length > 1
              ? p.fullName.split(' ').sublist(1).join(' ')
              : ''),
    );
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: profileCubit,
        child: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (prev, next) =>
            prev.isUpdating && !next.isUpdating && next.updateError == null,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.profileNameUpdatedSuccess)),
          );
          Navigator.of(dialogContext).pop();
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen: (prev, next) => prev.isUpdating != next.isUpdating,
          builder: (context, state) {
            return AlertDialog(
            title: Text(l10n.commonName),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DokalTextField(
                    controller: firstNameController,
                    label: l10n.authFirstName,
                    hint: l10n.authFirstName,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (v) {
                      if ((v ?? '').trim().isEmpty) return l10n.commonRequired;
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  DokalTextField(
                    controller: lastNameController,
                    label: l10n.authLastName,
                    hint: l10n.authLastName,
                    prefixIcon: Icons.badge_outlined,
                    validator: (v) {
                      if ((v ?? '').trim().isEmpty) return l10n.commonRequired;
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: state.isUpdating
                    ? null
                    : () => Navigator.of(context).pop(),
                child: Text(l10n.commonCancel),
              ),
              DokalButton.primary(
                onPressed: state.isUpdating
                    ? null
                    : () {
                        if (!(formKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        context.read<ProfileCubit>().updateName(
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                            );
                      },
                isLoading: state.isUpdating,
                child: Text(l10n.editRelativeSaveButton),
              ),
            ],
          );
        },
      ),
    ),
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

class _EditableNameRow extends StatelessWidget {
  const _EditableNameRow({
    required this.label,
    required this.profile,
    required this.onTap,
  });
  final String label;
  final UserProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.sm.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      profile.fullName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs.w),
                  Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
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
