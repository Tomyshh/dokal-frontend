import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
import '../../../practitioner/presentation/bloc/practitioner_cubit.dart';
import '../bloc/booking_bloc.dart';

class BookingFlowShell extends StatelessWidget {
  const BookingFlowShell({
    super.key,
    required this.practitionerId,
    required this.child,
  });

  final String practitionerId;
  final Widget child;

  static const _steps = <_Step>[
    _Step('Motif', '/booking/:id/reason'),
    _Step('Patient', '/booking/:id/patient'),
    _Step('Instructions', '/booking/:id/instructions'),
    _Step('Créneau', '/booking/:id/slot'),
    _Step('Confirmation', '/booking/:id/confirm'),
  ];

  int _stepIndexFromLocation(String matchedLocation) {
    if (matchedLocation.endsWith('/reason')) return 0;
    if (matchedLocation.endsWith('/patient')) return 1;
    if (matchedLocation.endsWith('/instructions')) return 2;
    if (matchedLocation.endsWith('/slot')) return 3;
    if (matchedLocation.endsWith('/confirm')) return 4;
    if (matchedLocation.endsWith('/success')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BookingBloc(practitionerId: practitionerId)),
        BlocProvider(create: (_) => sl<PractitionerCubit>(param1: practitionerId)),
      ],
      child: Builder(
        builder: (context) {
          final location = GoRouterState.of(context).matchedLocation;
          final idx = _stepIndexFromLocation(location);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              title: BlocBuilder<PractitionerCubit, PractitionerState>(
                builder: (context, pState) {
                  final name = pState.profile?.name ?? 'Praticien';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Prendre rendez-vous',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ],
                  );
                },
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/practitioner/$practitionerId');
                  }
                },
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.md,
                      AppSpacing.xl,
                      AppSpacing.md,
                    ),
                    child: Column(
                      children: [
                        _ProgressBar(current: idx, total: _steps.length),
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<BookingBloc, BookingState>(
                          builder: (context, state) {
                            return DokalCard(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withValues(alpha: 0.18),
                                        ),
                                        child: const Icon(
                                          Icons.medical_services_rounded,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: BlocBuilder<PractitionerCubit, PractitionerState>(
                                          builder: (context, pState) {
                                            final p = pState.profile;
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  p?.name ?? '—',
                                                  style: Theme.of(context).textTheme.titleMedium,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '${p?.specialty ?? '—'} • ${p?.address ?? '—'}',
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _SummaryPill(
                                        icon: Icons.medical_information_rounded,
                                        label: state.reason ?? 'Motif',
                                        isActive: state.reason != null,
                                      ),
                                      _SummaryPill(
                                        icon: Icons.person_rounded,
                                        label: state.patientLabel ?? 'Patient',
                                        isActive: state.patientLabel != null,
                                      ),
                                      _SummaryPill(
                                        icon: Icons.info_rounded,
                                        label: state.instructionsAccepted
                                            ? 'Instructions OK'
                                            : 'Instructions',
                                        isActive: state.instructionsAccepted,
                                      ),
                                      _SummaryPill(
                                        icon: Icons.schedule_rounded,
                                        label: state.slotLabel ?? 'Créneau',
                                        isActive: state.slotLabel != null,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(child: child),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = (current + 1) / total;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 10,
        backgroundColor: AppColors.outline,
        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final bg = isActive
        ? AppColors.accent.withValues(alpha: 0.10)
        : AppColors.textPrimary.withValues(alpha: 0.06);
    final fg = isActive ? AppColors.accent : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isActive ? AppColors.accent.withValues(alpha: 0.22) : AppColors.outline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 170),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }
}

class _Step {
  const _Step(this.label, this.pathTemplate);
  final String label;
  final String pathTemplate;
}

