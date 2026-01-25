import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_confirm_cubit.dart';

class ConfirmBookingPage extends StatelessWidget {
  const ConfirmBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final practitionerId = context.read<BookingBloc>().state.practitionerId;

    return BlocProvider(
      create: (_) => sl<BookingConfirmCubit>(),
      child: BlocConsumer<BookingConfirmCubit, BookingConfirmState>(
        listener: (context, state) {
          if (state.status == BookingConfirmStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Erreur')),
            );
          }
          if (state.status == BookingConfirmStatus.success) {
            context.go('/booking/$practitionerId/success');
          }
        },
        builder: (context, confirmState) {
          final isLoading = confirmState.status == BookingConfirmStatus.loading;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Text(
                'Confirmer le rendez-vous',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Vérifiez les informations avant de valider.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      DokalCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Row(
                              icon: Icons.medical_information_rounded,
                              title: 'Motif',
                              value: state.reason ?? '—',
                            ),
                            const SizedBox(height: 12),
                            _Row(
                              icon: Icons.person_rounded,
                              title: 'Patient',
                              value: state.patientLabel ?? '—',
                            ),
                            const SizedBox(height: 12),
                            _Row(
                              icon: Icons.schedule_rounded,
                              title: 'Créneau',
                              value: state.slotLabel ?? '—',
                            ),
                            const SizedBox(height: 12),
                            const _Row(
                              icon: Icons.location_on_rounded,
                              title: 'Adresse',
                              value: '83 Boulevard de la Villette, 75010 Paris',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DokalCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informations manquantes',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _InlineField(
                              label: 'Adresse',
                              value: state.addressLine ?? '',
                              onChanged: (v) => context
                                  .read<BookingBloc>()
                                  .add(BookingAddressChanged(v)),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _InlineField(
                              label: 'Code postal',
                              value: state.zipCode ?? '',
                              keyboardType: TextInputType.number,
                              onChanged: (v) => context
                                  .read<BookingBloc>()
                                  .add(BookingZipCodeChanged(v)),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _InlineField(
                              label: 'Ville',
                              value: state.city ?? '',
                              onChanged: (v) => context
                                  .read<BookingBloc>()
                                  .add(BookingCityChanged(v)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DokalCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Avez-vous déjà consulté ce praticien ?',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                Expanded(
                                  child: _YesNoButton(
                                    label: 'Oui',
                                    selected: state.visitedBefore == true,
                                    onTap: () => context.read<BookingBloc>().add(
                                          const BookingVisitedBeforeChanged(true),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: _YesNoButton(
                                    label: 'Non',
                                    selected: state.visitedBefore == false,
                                    onTap: () => context.read<BookingBloc>().add(
                                          const BookingVisitedBeforeChanged(false),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (isLoading) ...[
                        const DokalLoader(lines: 2),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      DokalButton.primary(
                        onPressed: (!state.isReadyToConfirm || isLoading)
                            ? null
                            : () => context.read<BookingConfirmCubit>().confirm(
                                  practitionerId: practitionerId,
                                  reason: state.reason!,
                                  patientLabel: state.patientLabel!,
                                  slotLabel: state.slotLabel!,
                                  addressLine: state.addressLine!.trim(),
                                  zipCode: state.zipCode!.trim(),
                                  city: state.city!.trim(),
                                  visitedBefore: state.visitedBefore!,
                                ),
                        leading: const Icon(Icons.check_rounded),
                        child: const Text('CONFIRMER LE RENDEZ-VOUS'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      DokalButton.outline(
                        onPressed: isLoading
                            ? null
                            : () => context.go('/booking/$practitionerId/slot'),
                        child: const Text('Modifier le créneau'),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _InlineField extends StatefulWidget {
  const _InlineField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.keyboardType,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  State<_InlineField> createState() => _InlineFieldState();
}

class _InlineFieldState extends State<_InlineField> {
  late final TextEditingController _c = TextEditingController(text: widget.value);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ok = _c.text.trim().isNotEmpty;
    return TextField(
      controller: _c,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: ok
            ? Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.primary)
            : null,
      ),
      onChanged: (v) {
        setState(() {});
        widget.onChanged(v);
      },
    );
  }
}

class _YesNoButton extends StatelessWidget {
  const _YesNoButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
        : Colors.white;
    final border = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).dividerColor;
    final fg = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

