import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/practitioner_profile.dart';
import '../bloc/practitioner_cubit.dart';

class PractitionerProfilePage extends StatelessWidget {
  const PractitionerProfilePage({super.key, required this.practitionerId});

  final String practitionerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PractitionerCubit>(param1: practitionerId),
      child: BlocBuilder<PractitionerCubit, PractitionerState>(
        builder: (context, state) {
          final PractitionerProfile? p = state.profile;

          return Scaffold(
            appBar: const DokalAppBar(title: 'Praticien'),
            body: SafeArea(
              child: state.status == PractitionerStatus.loading
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: DokalLoader(lines: 7),
                    )
                  : state.status == PractitionerStatus.failure
                      ? DokalEmptyState(
                          title: 'Praticien indisponible',
                          subtitle: state.error ?? 'Réessayez plus tard.',
                          icon: Icons.person_off_rounded,
                        )
                      : p == null
                          ? const DokalEmptyState(
                              title: 'Praticien introuvable',
                              subtitle: 'Ce profil est indisponible.',
                              icon: Icons.person_off_rounded,
                            )
                          : ListView(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              children: [
                                DokalCard(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(AppRadii.md),
                                        ),
                                        child: const Icon(
                                          Icons.person_rounded,
                                          color: AppColors.primary,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              p.specialty,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                DokalButton.primary(
                                  onPressed: () =>
                                      context.go('/booking/$practitionerId'),
                                  leading: const Icon(Icons.event_available_rounded),
                                  child: const Text('Prendre rendez-vous'),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                DokalButton.outline(
                                  onPressed: () => context.go('/messages/new'),
                                  leading: const Icon(Icons.mail_rounded),
                                  child: const Text('Envoyer un message'),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                _Section(
                                  title: 'Disponibilités',
                                  icon: Icons.schedule_rounded,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: p.nextAvailabilities
                                        .map(
                                          (a) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: Text(
                                              a,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                _Section(
                                  title: 'Adresse',
                                  icon: Icons.location_on_rounded,
                                  child: Text(
                                    p.address,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                _Section(
                                  title: 'Profil',
                                  icon: Icons.info_outline_rounded,
                                  child: Text(
                                    p.about,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
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

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DokalCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

