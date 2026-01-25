import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/appointment.dart';
import '../bloc/appointment_detail_cubit.dart';

class AppointmentDetailPage extends StatelessWidget {
  const AppointmentDetailPage({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppointmentDetailCubit>(param1: appointmentId)..load(),
      child: BlocConsumer<AppointmentDetailCubit, AppointmentDetailState>(
        listener: (context, state) {
          if (state.status == AppointmentDetailStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Erreur')),
            );
          }
          if (state.status == AppointmentDetailStatus.success &&
              state.appointment == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rendez-vous annulé')),
            );
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/appointments');
            }
          }
        },
        builder: (context, state) {
          final Appointment? a = state.appointment;
          return Scaffold(
            appBar: DokalAppBar(
              title: 'Détails du rendez-vous',
              actions: [
                IconButton(
                  icon: const Icon(Icons.share_rounded, size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Partage disponible bientôt')),
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: state.status == AppointmentDetailStatus.loading
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: DokalLoader(lines: 6),
                    )
                  : a == null
                      ? const DokalEmptyState(
                          title: 'Rendez-vous introuvable',
                          subtitle: 'Ce RDV est indisponible ou annulé.',
                          icon: Icons.event_busy_rounded,
                        )
                      : ListView(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          children: [
                            _AppointmentTopCard(a: a),
                            const SizedBox(height: AppSpacing.sm),
                            DokalCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () => context.go('/search'),
                                      icon: const Icon(Icons.sync_rounded, size: 16),
                                      label: Text(
                                        'Replanifier',
                                        style: Theme.of(context).textTheme.labelMedium,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 24,
                                    color: AppColors.outline,
                                  ),
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () async {
                                        final ok = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: Text(
                                                'Annuler le rendez-vous ?',
                                                style: Theme.of(context).textTheme.titleMedium,
                                              ),
                                              content: Text(
                                                'Cette action est définitive.',
                                                style: Theme.of(context).textTheme.bodySmall,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(ctx).pop(false),
                                                  child: const Text('Retour'),
                                                ),
                                                FilledButton(
                                                  onPressed: () => Navigator.of(ctx).pop(true),
                                                  child: const Text('Annuler'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (ok == true && context.mounted) {
                                          context.read<AppointmentDetailCubit>().cancel();
                                        }
                                      },
                                      icon: const Icon(Icons.close_rounded, size: 16, color: Colors.red),
                                      label: Text(
                                        'Annuler',
                                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                              color: Colors.red,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _SectionCard(
                              title: 'Préparation requise',
                              subtitle: 'Préparez votre consultation en avance.',
                              children: [
                                _PrepTile(
                                  icon: Icons.assignment_rounded,
                                  title: 'Remplir le questionnaire santé',
                                  statusLabel: 'À faire',
                                ),
                                const Divider(height: 1),
                                _PrepTile(
                                  icon: Icons.info_outline_rounded,
                                  title: 'Voir les instructions',
                                  statusLabel: 'À lire',
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _SectionCard(
                              title: 'Envoyer des documents',
                              subtitle: 'Envoyez des documents au praticien avant la consultation.',
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.upload_file_rounded, color: AppColors.primary),
                                  title: const Text('Ajouter des documents'),
                                  onTap: () => context.go('/health/documents'),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _SectionCard(
                              title: 'Vous voulez un créneau plus tôt ?',
                              subtitle: 'Recevez une alerte si un créneau plus tôt est disponible.',
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg,
                                    vertical: AppSpacing.md,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text('Activer les alertes')),
                                      Switch(value: false, onChanged: null),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            DokalButton.primary(
                              onPressed: () => context.go('/messages/c/demo1'),
                              leading: const Icon(Icons.mail_rounded),
                              child: const Text('Contacter le cabinet'),
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

class _AppointmentTopCard extends StatelessWidget {
  const _AppointmentTopCard({required this.a});
  final Appointment a;

  @override
  Widget build(BuildContext context) {
    return DokalCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 16, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${a.dateLabel} • ${a.timeLabel}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: const Icon(Icons.person_rounded, color: AppColors.primary),
            ),
            title: Text(a.practitionerName),
            subtitle: Text(a.specialty),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.go('/practitioner/p1'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.medical_information_rounded),
            title: Text(a.reason),
          ),
          if (a.address != null) ...[
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.location_on_rounded),
              title: Text(a.address!),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
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
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _PrepTile extends StatelessWidget {
  const _PrepTile({
    required this.icon,
    required this.title,
    required this.statusLabel,
  });

  final IconData icon;
  final String title;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          statusLabel,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Disponible bientôt')),
        );
      },
    );
  }
}

