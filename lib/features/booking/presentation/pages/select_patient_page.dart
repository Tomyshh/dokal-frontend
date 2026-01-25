import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../bloc/booking_patients_cubit.dart';
import '../bloc/booking_bloc.dart';

class SelectPatientPage extends StatelessWidget {
  const SelectPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final practitionerId = context.read<BookingBloc>().state.practitionerId;

    return BlocProvider(
      create: (_) => sl<BookingPatientsCubit>(),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pour qui est ce rendez-vous ?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: BlocBuilder<BookingPatientsCubit, BookingPatientsState>(
                builder: (context, pState) {
                  if (pState.status == BookingPatientsStatus.loading) {
                    return const DokalLoader(lines: 5);
                  }
                  if (pState.status == BookingPatientsStatus.failure) {
                    return DokalEmptyState(
                      title: 'Patients indisponibles',
                      subtitle: pState.error ?? 'Réessayez plus tard.',
                      icon: Icons.person_off_rounded,
                    );
                  }

                  return BlocBuilder<BookingBloc, BookingState>(
                    builder: (context, bookingState) {
                      final meName = pState.me.fullName;
                      final initials = _initials(meName);

                      return DokalCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.12),
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              title: Text(
                                '$meName (moi)',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              trailing: bookingState.patientLabel == 'Moi'
                                  ? Icon(Icons.check_circle_rounded,
                                      color: Theme.of(context).colorScheme.primary)
                                  : const Icon(Icons.chevron_right_rounded),
                              onTap: () {
                                context.read<BookingBloc>().add(
                                      const BookingPatientSelected('Moi'),
                                    );
                                context.go('/booking/$practitionerId/instructions');
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.sm,
                              ),
                              leading: Icon(
                                Icons.add_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              title: Text(
                                'Ajouter un proche',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              onTap: () => context.read<BookingPatientsCubit>().addRelativeDemo(),
                            ),
                            if (pState.relatives.isNotEmpty) ...[
                              const Divider(height: 1),
                              for (final r in pState.relatives)
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg,
                                    vertical: AppSpacing.sm,
                                  ),
                                  leading: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.10),
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(r.name),
                                  subtitle: Text(r.label),
                                  trailing: bookingState.patientLabel == r.name
                                      ? Icon(Icons.check_circle_rounded,
                                          color: Theme.of(context).colorScheme.primary)
                                      : const Icon(Icons.chevron_right_rounded),
                                  onTap: () {
                                    context.read<BookingBloc>().add(BookingPatientSelected(r.name));
                                    context.go('/booking/$practitionerId/instructions');
                                  },
                                ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  final letters = parts.take(2).where((p) => p.isNotEmpty).map((p) => p[0]).join();
  return letters.isEmpty ? 'ME' : letters.toUpperCase();
}

