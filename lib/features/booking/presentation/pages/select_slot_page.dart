import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/booking_bloc.dart';

class SelectSlotPage extends StatelessWidget {
  const SelectSlotPage({super.key});

  static final _slots = <({DateTime day, List<String> times})>[
    (day: DateTime(2026, 1, 28), times: <String>['11:00', '15:00', '16:00']),
    (day: DateTime(2026, 1, 29), times: <String>[]),
    (day: DateTime(2026, 2, 2), times: <String>[]),
    (day: DateTime(2026, 2, 3), times: <String>[]),
    (day: DateTime(2026, 2, 4), times: <String>[]),
    (day: DateTime(2026, 2, 5), times: <String>[]),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final practitionerId = context.read<BookingBloc>().state.practitionerId;
    final localeName = Localizations.localeOf(context).toString();

    return ListView(
      padding: EdgeInsets.all(AppSpacing.xl.r),
      children: [
        Text(
          l10n.bookingSelectSlotTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          l10n.bookingSelectSlotSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: AppSpacing.xl.h),
        BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            return Column(
              children: [
                for (final group in _slots)
                  _DateCard(
                    dayLabel: DateFormat.yMMMMEEEEd(
                      localeName,
                    ).format(group.day),
                    times: group.times,
                    selectedLabel: state.slotLabel,
                    onSelect: (t) {
                      final dayLabel = DateFormat.yMMMMEEEEd(
                        localeName,
                      ).format(group.day);
                      final label = '$dayLabel • $t';
                      context.read<BookingBloc>().add(
                        BookingSlotSelected(label),
                      );
                      context.go('/booking/$practitionerId/confirm');
                    },
                  ),
                SizedBox(height: AppSpacing.lg.h),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.commonAvailableSoon)),
                    );
                  },
                  child: Text(l10n.bookingSeeMoreDates),
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
    final l10n = context.l10n;
    final hasTimes = widget.times.isNotEmpty;
    final selectedForDay = (widget.selectedLabel ?? '').startsWith(
      widget.dayLabel,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
      child: DokalCard(
        padding: EdgeInsets.zero,
        onTap: hasTimes ? () => setState(() => _expanded = !_expanded) : null,
        child: Column(
          children: [
            ListTile(
              title: Text(widget.dayLabel),
              trailing: Icon(
                _expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
              ),
              subtitle: selectedForDay ? Text(l10n.commonSelected) : null,
              onTap: hasTimes
                  ? () => setState(() => _expanded = !_expanded)
                  : null,
            ),
            if (_expanded && hasTimes)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg.w,
                  0,
                  AppSpacing.lg.w,
                  AppSpacing.lg.h,
                ),
                child: Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: [
                    for (final t in widget.times)
                      _TimeBox(
                        label: t,
                        selected:
                            widget.selectedLabel == '${widget.dayLabel} • $t',
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
    final border = selected
        ? Theme.of(context).colorScheme.primary
        : Colors.transparent;
    final fg = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: onTap,
      child: Container(
        width: 96.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8.r),
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
