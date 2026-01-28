import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<ProfileCubit>(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final UserProfile? p = state.profile;
          return Scaffold(
            appBar: DokalAppBar(title: l10n.profileTitle),
            body: SafeArea(
              child: state.status == ProfileStatus.loading
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
                      ],
                    ),
            ),
          );
        },
      ),
    );
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
