import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/format_time_slot.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/usecases/confirm_booking.dart';
import '../../../practitioner/domain/entities/practitioner_profile.dart';
import '../bloc/booking_patients_cubit.dart';
import '../bloc/quick_booking_cubit.dart';

/// Bottom sheet pour une prise de rendez-vous rapide et guidée.
/// Affiche : Patient → Confirmation → Création.
class QuickBookingSheet extends StatelessWidget {
  const QuickBookingSheet({
    super.key,
    required this.practitionerId,
    required this.practitionerName,
    required this.profile,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
  });

  final String practitionerId;
  final String practitionerName;
  final PractitionerProfile profile;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;

  static Future<void> show(
    BuildContext context, {
    required String practitionerId,
    required String practitionerName,
    required PractitionerProfile profile,
    required DateTime appointmentDate,
    required String startTime,
    required String endTime,
  }) {
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
          builder: (_, scrollController) => QuickBookingSheet(
          practitionerId: practitionerId,
          practitionerName: practitionerName,
          profile: profile,
          appointmentDate: appointmentDate,
          startTime: startTime,
          endTime: endTime,
        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<BookingPatientsCubit>()..load(),
        ),
        BlocProvider(
          create: (_) => QuickBookingCubit(
            confirmBooking: sl<ConfirmBooking>(),
            practitionerId: practitionerId,
            appointmentDate: DateFormat('yyyy-MM-dd').format(appointmentDate),
            startTime: startTime,
            endTime: endTime,
          ),
        ),
      ],
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
              child: BlocConsumer<QuickBookingCubit, QuickBookingState>(
                listener: (context, state) {
                  if (state.status == QuickBookingStatus.success &&
                      state.appointmentId != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.bookingSuccessTitle),
                        backgroundColor: AppColors.accent,
                      ),
                    );
                    Navigator.of(context).pop();
                    context.go('/appointments/${state.appointmentId}');
                  }
                  if (state.status == QuickBookingStatus.failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error ?? l10n.commonError)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.step == QuickBookingStep.patient) {
                    return _PatientStep(
                      onPatientSelected: (relativeId, label) {
                        context.read<QuickBookingCubit>().selectPatient(
                              relativeId: relativeId,
                              patientLabel: label,
                            );
                      },
                      onNext: () {
                        context.read<QuickBookingCubit>().goToConfirm();
                      },
                    );
                  }
                  return _ConfirmStep(
                    practitionerName: practitionerName,
                    profile: profile,
                    onConfirm: () {
                      context.read<QuickBookingCubit>().confirm();
                    },
                    isLoading: state.status == QuickBookingStatus.loading,
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

class _PatientStep extends StatelessWidget {
  const _PatientStep({
    required this.onPatientSelected,
    required this.onNext,
  });

  final void Function(String? relativeId, String label) onPatientSelected;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<BookingPatientsCubit, BookingPatientsState>(
      builder: (context, pState) {
        return BlocBuilder<QuickBookingCubit, QuickBookingState>(
          builder: (context, state) {
            final hasPatient = state.patientLabel != null;

            if (pState.status == BookingPatientsStatus.loading) {
              return Padding(
                padding: EdgeInsets.all(AppSpacing.xl.r),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            if (pState.status == BookingPatientsStatus.failure) {
              return Padding(
                padding: EdgeInsets.all(AppSpacing.xl.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 48.sp),
                    SizedBox(height: 16.h),
                    Text(pState.error ?? l10n.commonError),
                  ],
                ),
              );
            }

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
                    l10n.bookingSelectPatientTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.bookingQuickPatientSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w),
                    child: DokalCard(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.md.h,
                        horizontal: AppSpacing.sm.w,
                      ),
                      child: Column(
                        children: [
                          _PatientTile(
                            name: pState.me.fullName,
                            label: null,
                            isSelected: state.patientLabel == pState.me.fullName,
                            onTap: () => onPatientSelected(null, pState.me.fullName),
                          ),
                          if (pState.relatives.isNotEmpty) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
                              child: Divider(height: 1.h, indent: 72.w, endIndent: 16.w),
                            ),
                            ...pState.relatives.map(
                              (r) => Padding(
                                padding: EdgeInsets.only(top: AppSpacing.sm.h),
                                child: _PatientTile(
                                  name: r.name,
                                  label: r.label,
                                  isSelected: state.patientLabel == r.name,
                                  onTap: () => onPatientSelected(r.id, r.name),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  DokalButton.primary(
                    onPressed: hasPatient ? onNext : null,
                    leading: const Icon(Icons.arrow_forward_rounded),
                    child: Text(l10n.commonContinue),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PatientTile extends StatelessWidget {
  const _PatientTile({
    required this.name,
    this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final String? label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .take(2)
        .where((p) => p.isNotEmpty)
        .map((p) => p[0])
        .join()
        .toUpperCase();
    final displayInitials = initials.isEmpty ? '?' : initials;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      minVerticalPadding: 16.h,
      leading: CircleAvatar(
        radius: 24.r,
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        child: Text(
          displayInitials,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
          ),
        ),
      ),
      title: Text(
        name,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: label != null && label!.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                label!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            )
          : null,
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 26.sp)
          : null,
      onTap: onTap,
    );
  }
}

String _formatSlotDisplay(BuildContext context, QuickBookingState state) {
  try {
    final parts = state.appointmentDate.split('-');
    if (parts.length == 3) {
      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      final locale = Localizations.localeOf(context).toString();
      final formatted = DateFormat('EEEE d MMMM', locale).format(date);
      final start24 = formatTimeTo24h(state.startTime);
      final end24 = formatTimeTo24h(state.endTime);
      return '$start24 - $end24 • $formatted';
    }
  } catch (_) {}
  final start24 = formatTimeTo24h(state.startTime);
  final end24 = formatTimeTo24h(state.endTime);
  return '$start24 - $end24 • ${state.appointmentDate}';
}

class _ConfirmStep extends StatelessWidget {
  const _ConfirmStep({
    required this.practitionerName,
    required this.profile,
    required this.onConfirm,
    required this.isLoading,
  });

  final String practitionerName;
  final PractitionerProfile profile;
  final VoidCallback onConfirm;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<QuickBookingCubit>().state;

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
            l10n.bookingConfirmTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.bookingQuickConfirmSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          SizedBox(height: AppSpacing.xl.h),
          DokalCard(
            padding: EdgeInsets.all(AppSpacing.md.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryRow(
                  icon: Icons.calendar_today_rounded,
                  title: l10n.bookingSlotLabel,
                  value: _formatSlotDisplay(context, state),
                ),
                SizedBox(height: 12.h),
                _SummaryRow(
                  icon: Icons.person_rounded,
                  title: l10n.bookingPatientLabel,
                  value: state.patientLabel ?? '—',
                ),
                SizedBox(height: 12.h),
                _SummaryRow(
                  icon: Icons.medical_services_rounded,
                  title: l10n.practitionerTitle,
                  value: '$practitionerName • ${profile.specialty}',
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          DokalButton.primary(
            onPressed: isLoading ? null : onConfirm,
            leading: isLoading
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_rounded),
            child: Text(
              isLoading ? l10n.commonLoading : l10n.bookingConfirmButton,
            ),
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: isLoading
                ? null
                : () => context.read<QuickBookingCubit>().goToPatient(),
            child: Text(l10n.bookingChangePatient),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
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
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
