import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        title: Text(
          'Mon compte',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            DokalCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Votre santé. Vos données.',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Votre confidentialité est notre priorité.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(title: 'Informations personnelles'),
            const SizedBox(height: AppSpacing.sm),
            _MenuTile(
              icon: Icons.person_rounded,
              title: 'Mon profil',
              onTap: () => context.go('/account/profile'),
            ),
            const SizedBox(height: AppSpacing.xs),
            _MenuTile(
              icon: Icons.group_rounded,
              title: 'Mes proches',
              onTap: () => context.go('/account/relatives'),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(title: 'Compte'),
            const SizedBox(height: AppSpacing.sm),
            _MenuTile(
              icon: Icons.lock_rounded,
              title: 'Sécurité',
              onTap: () => context.go('/account/security'),
            ),
            const SizedBox(height: AppSpacing.xs),
            _MenuTile(
              icon: Icons.payments_rounded,
              title: 'Paiement',
              onTap: () => context.go('/account/payment'),
            ),
            const SizedBox(height: AppSpacing.xs),
            _MenuTile(
              icon: Icons.tune_rounded,
              title: 'Paramètres',
              onTap: () => context.go('/account/settings'),
            ),
            const SizedBox(height: AppSpacing.xs),
            _MenuTile(
              icon: Icons.privacy_tip_rounded,
              title: 'Confidentialité',
              onTap: () => context.go('/account/privacy'),
            ),
            const SizedBox(height: AppSpacing.lg),
            _MenuTile(
              icon: Icons.logout_rounded,
              title: 'Se déconnecter',
              showChevron: false,
              onTap: () => context.read<AuthBloc>().add(
                    const AuthLogoutRequested(),
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
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return DokalCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          if (showChevron)
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
        ],
      ),
    );
  }
}

