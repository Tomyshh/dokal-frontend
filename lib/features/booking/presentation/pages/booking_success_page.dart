import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/booking_bloc.dart';

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.read<BookingBloc>().state;
    final slot = state.slotLabel ?? '—';
    final patient = state.patientLabel ?? '—';

    return ListView(
      padding: EdgeInsets.all(AppSpacing.xl.r),
      children: [
        Center(
          child: Icon(
            Icons.check_circle_rounded,
            size: 52.sp,
            color: AppColors.accent,
          ),
        ),
        SizedBox(height: AppSpacing.lg.h),
        Text(
          l10n.bookingSuccessTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          l10n.bookingSuccessSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.xl.h),
        _AppointmentSummaryCard(
          slotLabel: slot,
          practitionerName: 'Dr Dan BOTBOL',
          specialty: 'Dentiste',
          patientLabel: patient,
          reason: state.reason ?? '—',
        ),
        SizedBox(height: AppSpacing.md.h),
        DokalCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                ),
                title: Text(l10n.bookingAddToCalendar),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.commonAvailableSoon)),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.primary,
                ),
                title: Text(l10n.bookingBookAnotherAppointment),
                onTap: () => context.go('/search'),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _SectionCard(
          title: l10n.appointmentDetailPreparationTitle,
          subtitle: l10n.appointmentDetailPreparationSubtitle,
          children: [
            _PrepTile(
              icon: Icons.assignment_rounded,
              title: l10n.appointmentDetailPrepQuestionnaire,
              statusLabel: l10n.commonTodo,
            ),
            const Divider(height: 1),
            _PrepTile(
              icon: Icons.info_outline_rounded,
              title: l10n.appointmentDetailPrepInstructions,
              statusLabel: l10n.commonToRead,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        _SectionCard(
          title: l10n.appointmentDetailEarlierSlotTitle,
          subtitle: l10n.appointmentDetailEarlierSlotSubtitle,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg.w,
                vertical: AppSpacing.md.h,
              ),
              child: Row(
                children: [
                  Expanded(child: Text(l10n.appointmentDetailEnableAlerts)),
                  const Switch(value: false, onChanged: null),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg.h),
        DokalButton.primary(
          onPressed: () => context.go('/appointments'),
          leading: const Icon(Icons.event_available_rounded),
          child: Text(l10n.bookingViewMyAppointments),
        ),
        SizedBox(height: AppSpacing.sm.h),
        DokalButton.outline(
          onPressed: () => context.go('/home'),
          child: Text(l10n.bookingBackToHome),
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
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.w,
              vertical: AppSpacing.md.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withValues(alpha: 0.85),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16.sp,
                  color: Colors.white,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    slotLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
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
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg.w,
              AppSpacing.lg.h,
              AppSpacing.lg.w,
              AppSpacing.sm.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 4.h),
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
    final l10n = context.l10n;
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          statusLabel,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
          ),
        ),
      ),
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.commonAvailableSoon)));
      },
    );
  }
}
