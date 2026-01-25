import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final UserProfile? p = state.profile;
          return Scaffold(
            appBar: const DokalAppBar(title: 'Mon profil'),
            body: SafeArea(
              child: state.status == ProfileStatus.loading
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: DokalLoader(lines: 5),
                    )
                  : state.status == ProfileStatus.failure
                      ? DokalEmptyState(
                          title: 'Profil indisponible',
                          subtitle: state.error ?? 'Réessayez plus tard.',
                          icon: Icons.person_off_rounded,
                        )
                      : p == null
                          ? const DokalEmptyState(
                              title: 'Profil indisponible',
                              subtitle: 'Vos informations sont indisponibles.',
                              icon: Icons.person_off_rounded,
                            )
                          : ListView(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              children: [
                                _ProfileSection(
                                  title: 'Identité',
                                  children: [
                                    _InfoRow(label: 'Nom', value: p.fullName),
                                    _InfoRow(label: 'Email', value: p.email),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.md),
                                _ProfileSection(
                                  title: 'Adresse',
                                  children: [
                                    _InfoRow(label: 'Ville', value: p.city),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.md),
                                const _ProfileSection(
                                  title: 'Informations médicales',
                                  children: [
                                    _InfoRow(label: 'Groupe sanguin', value: '—'),
                                    _InfoRow(label: 'Taille', value: '—'),
                                    _InfoRow(label: 'Poids', value: '—'),
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
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.sm,
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
          const SizedBox(height: AppSpacing.sm),
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

