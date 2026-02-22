import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/format_appointment_date.dart';
import '../../../../core/utils/format_time_slot.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/notifiers/appointment_refresh_notifier.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/usecases/reschedule_appointment.dart';
import '../../../practitioner/domain/usecases/get_practitioner_slots.dart';
import '../bloc/reschedule_cubit.dart';
import '../bloc/reschedule_state.dart';

/// Bottom sheet pour replanifier un rendez-vous.
/// Affiche un calendrier + sélection de créneau, puis confirmation.
class RescheduleSheet extends StatelessWidget {
  const RescheduleSheet({
    super.key,
    required this.appointment,
  });

  final Appointment appointment;

  static Future<void> show(BuildContext context, {required Appointment appointment}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) => RescheduleSheet(appointment: appointment),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => RescheduleCubit(
        rescheduleAppointment: sl<RescheduleAppointment>(),
        appointmentId: appointment.id,
        practitionerId: appointment.practitionerId,
        practitionerName: appointment.practitionerName,
        currentDateLabel: formatAppointmentDateLabel(context, appointment.dateLabel),
        currentTimeLabel: appointment.timeLabel,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: _HandleBar(),
              ),
              Flexible(
                child: BlocConsumer<RescheduleCubit, RescheduleState>(
                  listener: (context, state) {
                    if (state.status == RescheduleStatus.success) {
                      sl<AppointmentRefreshNotifier>().notifyAppointmentChanged();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.appointmentRescheduleSuccessSnack),
                          backgroundColor: AppColors.accent,
                        ),
                      );
                      Navigator.of(context).pop();
                      if (state.updatedAppointment != null) {
                        context.go('/appointments/${state.updatedAppointment!.id}');
                      }
                    }
                    if (state.status == RescheduleStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error ?? l10n.commonError)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg.w,
                        0,
                        AppSpacing.lg.w,
                        AppSpacing.xl.h + MediaQuery.of(context).padding.bottom,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.appointmentRescheduleTitle,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            l10n.appointmentRescheduleSubtitle(state.practitionerName),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.all(AppSpacing.sm.r),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded,
                                    size: 18.sp, color: AppColors.textSecondary),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    l10n.appointmentRescheduleCurrent(
                                      state.currentDateLabel,
                                      state.currentTimeLabel,
                                    ),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.lg.h),
                          _RescheduleSlotPicker(
                            practitionerId: appointment.practitionerId,
                            getSlots: sl<GetPractitionerSlots>(),
                            selectedDate: state.selectedDate,
                            selectedTime: state.selectedTime,
                            onDateSelected: (d) =>
                                context.read<RescheduleCubit>().selectDate(d),
                            onSlotSelected: (s) =>
                                context.read<RescheduleCubit>().selectSlot(
                                      start: s.start,
                                      end: s.end,
                                    ),
                          ),
                          if (state.canConfirm) ...[
                            SizedBox(height: AppSpacing.lg.h),
                            DokalButton.primary(
                              onPressed: state.status == RescheduleStatus.loading
                                  ? null
                                  : () => context.read<RescheduleCubit>().confirm(),
                              leading: state.status == RescheduleStatus.loading
                                  ? SizedBox(
                                      width: 20.r,
                                      height: 20.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.check_rounded),
                              child: Text(
                                state.status == RescheduleStatus.loading
                                    ? l10n.commonLoading
                                    : l10n.appointmentRescheduleConfirm,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HandleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColors.outline.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

class _RescheduleSlotPicker extends StatefulWidget {
  const _RescheduleSlotPicker({
    required this.practitionerId,
    required this.getSlots,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onSlotSelected,
  });

  final String practitionerId;
  final GetPractitionerSlots getSlots;
  final DateTime? selectedDate;
  final String? selectedTime;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<({String start, String end})> onSlotSelected;

  @override
  State<_RescheduleSlotPicker> createState() => _RescheduleSlotPickerState();
}

class _RescheduleSlotPickerState extends State<_RescheduleSlotPicker> {
  late DateTime _currentMonth;
  final DateTime _today = DateTime.now();
  Set<DateTime> _availableDates = {};
  bool _isLoadingSlots = true;
  String? _slotsError;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(_today.year, _today.month);
    _loadSlotsForMonth();
  }

  Future<void> _loadSlotsForMonth() async {
    if (!mounted) return;
    setState(() {
      _isLoadingSlots = true;
      _slotsError = null;
    });

    final from = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final to = DateTime(lastDay.year, lastDay.month, lastDay.day);
    final fromStr = DateFormat('yyyy-MM-dd').format(from);
    final toStr = DateFormat('yyyy-MM-dd').format(to);

    final result = await widget.getSlots(
      widget.practitionerId,
      from: fromStr,
      to: toStr,
    );

    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _availableDates = {};
        _isLoadingSlots = false;
        _slotsError = failure.message;
      }),
      (slots) {
        final dates = <DateTime>{};
        for (final slot in slots) {
          final dateStr = slot['slot_date'];
          if (dateStr != null && dateStr.isNotEmpty) {
            final parsed = DateTime.tryParse(dateStr);
            if (parsed != null) {
              dates.add(DateTime(parsed.year, parsed.month, parsed.day));
            }
          }
        }
        setState(() {
          _availableDates = dates;
          _isLoadingSlots = false;
          _slotsError = null;
        });
      },
    );
  }

  bool _isAvailable(DateTime date) =>
      _availableDates.contains(DateTime(date.year, date.month, date.day));

  bool _isToday(DateTime date) =>
      date.year == _today.year &&
      date.month == _today.month &&
      date.day == _today.day;

  bool _isSelected(DateTime date) {
    if (widget.selectedDate == null) return false;
    return date.year == widget.selectedDate!.year &&
        date.month == widget.selectedDate!.month &&
        date.day == widget.selectedDate!.day;
  }

  void _previousMonth() {
    if (_currentMonth.isAfter(DateTime(_today.year, _today.month))) {
      setState(() {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      });
      _loadSlotsForMonth();
    }
  }

  void _nextMonth() {
    final maxMonth = DateTime(_today.year, _today.month + 2);
    if (_currentMonth.isBefore(maxMonth)) {
      setState(() {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      });
      _loadSlotsForMonth();
    }
  }

  String _getMonthName(BuildContext context, int month, int year) {
    final locale = Localizations.localeOf(context);
    final localeStr = locale.countryCode != null && locale.countryCode!.isNotEmpty
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    return DateFormat('MMMM yyyy', localeStr).format(DateTime(year, month));
  }

  List<String> _getWeekdayAbbreviations(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeStr = locale.countryCode != null && locale.countryCode!.isNotEmpty
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    final format = DateFormat('E', localeStr);
    return List.generate(7, (i) {
      final date = DateTime.utc(2024, 1, 7 + i);
      return format.format(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;
    final firstDayOfWeek = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    ).weekday;
    final startOffset = firstDayOfWeek == 7 ? 0 : firstDayOfWeek;

    final canGoBack = _currentMonth.isAfter(DateTime(_today.year, _today.month));
    final canGoNext =
        _currentMonth.isBefore(DateTime(_today.year, _today.month + 2));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DokalCard(
          padding: EdgeInsets.all(AppSpacing.md.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) {
                  final isRtl = Localizations.localeOf(context).languageCode == 'he';
                  final prevBtn = GestureDetector(
                    onTap: canGoBack ? _previousMonth : null,
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: canGoBack
                            ? AppColors.surfaceVariant
                            : AppColors.surfaceVariant.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 20.sp,
                        color: canGoBack
                            ? AppColors.textPrimary
                            : AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                  final nextBtn = GestureDetector(
                    onTap: canGoNext ? _nextMonth : null,
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: canGoNext
                            ? AppColors.surfaceVariant
                            : AppColors.surfaceVariant.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 20.sp,
                        color: canGoNext
                            ? AppColors.textPrimary
                            : AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                  final monthText = Text(
                    _getMonthName(
                        context, _currentMonth.month, _currentMonth.year),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                  );
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: isRtl
                        ? [nextBtn, monthText, prevBtn]
                        : [prevBtn, monthText, nextBtn],
                  );
                },
              ),
              SizedBox(height: AppSpacing.md.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _getWeekdayAbbreviations(context)
                    .map(
                      (day) => SizedBox(
                        width: 36.r,
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 8.h),
              if (_isLoadingSlots)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.r,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                )
              else if (_slotsError != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    _slotsError!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 4.h,
                    crossAxisSpacing: 4.w,
                    childAspectRatio: 1,
                  ),
                  itemCount: startOffset + daysInMonth,
                  itemBuilder: (context, index) {
                    if (index < startOffset) return const SizedBox();
                    final day = index - startOffset + 1;
                    final date = DateTime(
                      _currentMonth.year,
                      _currentMonth.month,
                      day,
                    );
                    final isAvailable = _isAvailable(date);
                    final isToday = _isToday(date);
                    final isSelected = _isSelected(date);
                    final isPast = date.isBefore(
                      DateTime(_today.year, _today.month, _today.day),
                    );

                    return GestureDetector(
                      onTap: isAvailable && !isPast
                          ? () => widget.onDateSelected(date)
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected && isAvailable
                              ? AppColors.primary
                              : isAvailable && !isPast
                                  ? AppColors.accent.withValues(alpha: 0.1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                          border: isToday
                              ? Border.all(color: AppColors.primary, width: 1.5.w)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected && isAvailable
                                  ? Colors.white
                                  : isPast
                                      ? AppColors.textSecondary
                                          .withValues(alpha: 0.4)
                                      : isAvailable
                                          ? AppColors.textPrimary
                                          : AppColors.textSecondary
                                              .withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        if (widget.selectedDate != null) ...[
          SizedBox(height: AppSpacing.sm.h),
          _TimeSlotSection(
            practitionerId: widget.practitionerId,
            getSlots: widget.getSlots,
            selectedDate: widget.selectedDate!,
            selectedTime: widget.selectedTime,
            onSlotSelected: widget.onSlotSelected,
          ),
        ],
      ],
    );
  }
}

String _addMinutesToTime(String time, int minutes) {
  final parts = time.split(':');
  if (parts.length < 2) return time;
  var h = int.tryParse(parts[0]) ?? 0;
  var m = int.tryParse(parts[1]) ?? 0;
  m += minutes;
  h += m ~/ 60;
  m = m % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

class _TimeSlotSection extends StatefulWidget {
  const _TimeSlotSection({
    required this.practitionerId,
    required this.getSlots,
    required this.selectedDate,
    required this.selectedTime,
    required this.onSlotSelected,
  });

  final String practitionerId;
  final GetPractitionerSlots getSlots;
  final DateTime selectedDate;
  final String? selectedTime;
  final ValueChanged<({String start, String end})> onSlotSelected;

  @override
  State<_TimeSlotSection> createState() => _TimeSlotSectionState();
}

class _TimeSlotSectionState extends State<_TimeSlotSection> {
  List<({String start, String end})> _slots = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSlotsForDate();
  }

  @override
  void didUpdateWidget(covariant _TimeSlotSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadSlotsForDate();
    }
  }

  Future<void> _loadSlotsForDate() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final dateStr = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    final result = await widget.getSlots(
      widget.practitionerId,
      from: dateStr,
      to: dateStr,
    );

    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _slots = [];
        _isLoading = false;
        _error = failure.message;
      }),
      (slots) {
        final list = <({String start, String end})>[];
        for (final slot in slots) {
          final start = slot['slot_start'];
          final end = slot['slot_end'];
          if (start != null && start.isNotEmpty) {
            final startDisplay = formatTimeTo24h(start);
            final endDisplay = end != null && end.isNotEmpty
                ? formatTimeTo24h(end)
                : _addMinutesToTime(formatTimeTo24h(start), 30);
            list.add((start: startDisplay, end: endDisplay));
          }
        }
        list.sort((a, b) => a.start.compareTo(b.start));
        setState(() {
          _slots = list;
          _isLoading = false;
          _error = null;
        });
      },
    );
  }

  String _formatDate(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return DateFormat('EEEE, d/M', locale.toLanguageTag())
        .format(widget.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DokalCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 20.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 10.w),
              Text(
                _formatDate(context),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.r,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          else if (_error != null)
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            )
          else if (_slots.isEmpty)
            Text(
              l10n.practitionerNoSlotsForDate,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            )
          else
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: _slots.map((slot) {
                final isSelected = widget.selectedTime == slot.start;
                return GestureDetector(
                  onTap: () => widget.onSlotSelected((start: slot.start, end: slot.end)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.2),
                        width: isSelected ? 2.r : 1.r,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 8.r,
                                offset: Offset(0, 4.h),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      slot.start,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
