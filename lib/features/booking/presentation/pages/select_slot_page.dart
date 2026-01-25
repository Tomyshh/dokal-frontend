import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../bloc/booking_bloc.dart';

class SelectSlotPage extends StatelessWidget {
  const SelectSlotPage({super.key});

  static const _slots = <({String dayLabel, List<String> times})>[
    (dayLabel: 'Mercredi 28 Janvier 2026', times: ['11:00', '15:00', '16:00']),
    (dayLabel: 'Jeudi 29 Janvier 2026', times: []),
    (dayLabel: 'Lundi 2 Février 2026', times: []),
    (dayLabel: 'Mardi 3 Février 2026', times: []),
    (dayLabel: 'Mercredi 4 Février 2026', times: []),
    (dayLabel: 'Jeudi 5 Février 2026', times: []),
  ];

  @override
  Widget build(BuildContext context) {
    final practitionerId = context.read<BookingBloc>().state.practitionerId;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Text(
          'Choisir une date',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Sélectionnez une date et un horaire disponibles.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xl),
        BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            return Column(
              children: [
                for (final group in _slots)
                  _DateCard(
                    dayLabel: group.dayLabel,
                    times: group.times,
                    selectedLabel: state.slotLabel,
                    onSelect: (t) {
                      final label = '${group.dayLabel} • $t';
                      context.read<BookingBloc>().add(BookingSlotSelected(label));
                      context.go('/booking/$practitionerId/confirm');
                    },
                  ),
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Plus de dates bientôt')),
                    );
                  },
                  child: const Text('Voir plus de dates'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DateCard extends StatefulWidget {
  const _DateCard({
    required this.dayLabel,
    required this.times,
    required this.selectedLabel,
    required this.onSelect,
  });

  final String dayLabel;
  final List<String> times;
  final String? selectedLabel;
  final void Function(String time) onSelect;

  @override
  State<_DateCard> createState() => _DateCardState();
}

class _DateCardState extends State<_DateCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasTimes = widget.times.isNotEmpty;
    final selectedForDay = (widget.selectedLabel ?? '').startsWith(widget.dayLabel);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: DokalCard(
        padding: EdgeInsets.zero,
        onTap: hasTimes ? () => setState(() => _expanded = !_expanded) : null,
        child: Column(
          children: [
            ListTile(
              title: Text(widget.dayLabel),
              trailing: Icon(
                _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
              ),
              subtitle: selectedForDay ? const Text('Sélectionné') : null,
              onTap: hasTimes ? () => setState(() => _expanded = !_expanded) : null,
            ),
            if (_expanded && hasTimes)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final t in widget.times)
                      _TimeBox(
                        label: t,
                        selected: widget.selectedLabel == '${widget.dayLabel} • $t',
                        onTap: () => widget.onSelect(t),
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

class _TimeBox extends StatelessWidget {
  const _TimeBox({
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
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
        : Theme.of(context).colorScheme.primary.withValues(alpha: 0.08);
    final border =
        selected ? Theme.of(context).colorScheme.primary : Colors.transparent;
    final fg = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: 96,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border, width: 1.2),
        ),
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

