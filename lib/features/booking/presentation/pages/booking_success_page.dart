import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../bloc/booking_bloc.dart';

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BookingBloc>().state;
    final slot = state.slotLabel ?? '—';
    final patient = state.patientLabel ?? '—';

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Center(
          child: Icon(
            Icons.check_circle_rounded,
            size: 52,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Rendez-vous confirmé',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Nous avons envoyé une confirmation à votre email.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        _AppointmentSummaryCard(
          slotLabel: slot,
          practitionerName: 'Dr Dan BOTBOL',
          specialty: 'Dentiste',
          patientLabel: patient,
          reason: state.reason ?? '—',
        ),
        const SizedBox(height: AppSpacing.md),
        DokalCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
                title: const Text('Ajouter à mon calendrier'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calendrier disponible bientôt')),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                title: const Text('Reprendre un rendez-vous'),
                onTap: () => context.go('/search'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
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
          subtitle: 'Envoyez des documents à votre praticien pour la consultation.',
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
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
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
          onPressed: () => context.go('/appointments'),
          leading: const Icon(Icons.event_available_rounded),
          child: const Text('Voir mes rendez-vous'),
        ),
        const SizedBox(height: AppSpacing.sm),
        DokalButton.outline(
          onPressed: () => context.go('/home'),
          child: const Text('Retour à l’accueil'),
        ),
      ],
    );
  }
}

class _AppointmentSummaryCard extends StatelessWidget {
  const _AppointmentSummaryCard({
    required this.slotLabel,
    required this.practitionerName,
    required this.specialty,
    required this.patientLabel,
    required this.reason,
  });

  final String slotLabel;
  final String practitionerName;
  final String specialty;
  final String patientLabel;
  final String reason;

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
                    slotLabel,
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
            title: Text(practitionerName),
            subtitle: Text(specialty),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: Text(patientLabel),
            subtitle: Text(reason),
          ),
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

