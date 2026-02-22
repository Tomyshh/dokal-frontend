import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/format_appointment_date.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/appointment.dart';
import '../bloc/appointment_detail_cubit.dart';
import '../widgets/reschedule_sheet.dart';

class AppointmentDetailPage extends StatelessWidget {
  const AppointmentDetailPage({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<AppointmentDetailCubit>(param1: appointmentId)..load(),
      child: BlocConsumer<AppointmentDetailCubit, AppointmentDetailState>(
        listener: (context, state) {
          if (state.status == AppointmentDetailStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? l10n.commonError)),
            );
          }
          if (state.status == AppointmentDetailStatus.success &&
              state.appointment == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.appointmentDetailCancelledSnack)),
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
              title: l10n.appointmentDetailTitle,
              actions: [
                IconButton(
                  icon: Icon(Icons.share_rounded, size: 20.sp),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.commonAvailableSoon)),
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: state.status == AppointmentDetailStatus.loading
                  ? Padding(
                      padding: EdgeInsets.all(AppSpacing.lg.r),
                      child: const DokalLoader(lines: 6),
                    )
                  : a == null
                      ? DokalEmptyState(
                          title: l10n.appointmentDetailNotFoundTitle,
                          subtitle: l10n.appointmentDetailNotFoundSubtitle,
                          icon: Icons.event_busy_rounded,
                        )
                      : ListView(
                          padding: EdgeInsets.all(AppSpacing.lg.r),
                          children: [
                            _AppointmentTopCard(a: a),
                            SizedBox(height: AppSpacing.sm.h),
                            if (!a.isPast) ...[
                              _ActionBar(a: a),
                              SizedBox(height: AppSpacing.md.h),
                            ] else ...[
                              _SectionCard(
                                title:
                                    l10n.appointmentDetailVisitSummaryTitle,
                                subtitle:
                                    l10n.appointmentDetailVisitSummarySubtitle,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      AppSpacing.lg.w,
                                      0,
                                      AppSpacing.lg.w,
                                      AppSpacing.lg.h,
                                    ),
                                    child: Text(
                                      l10n.appointmentDetailVisitSummaryDemo,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSpacing.md.h),
                              _SectionCard(
                                title:
                                    l10n.appointmentDetailDoctorReportTitle,
                                subtitle:
                                    l10n.appointmentDetailDoctorReportSubtitle,
                                children: [
                                  _DetailTile(
                                    icon: Icons.description_rounded,
                                    title:
                                        l10n.appointmentDetailOpenVisitReport,
                                    onTap: () => showDialog<void>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(
                                          l10n.appointmentDetailDoctorReportTitle,
                                        ),
                                        content: Text(
                                          l10n.appointmentDetailDoctorReportDemo,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(),
                                            child: Text(l10n.commonBack),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSpacing.md.h),
                              _SectionCard(
                                title:
                                    l10n.appointmentDetailDocumentsAndRxTitle,
                                subtitle:
                                    l10n.appointmentDetailDocumentsAndRxSubtitle,
                                children: [
                                  _DetailTile(
                                    icon: Icons.receipt_long_rounded,
                                    title:
                                        l10n.appointmentDetailOpenPrescription,
                                    onTap: () => ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content:
                                            Text(l10n.commonAvailableSoon),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSpacing.lg.h),
                              DokalButton.primary(
                                onPressed: () {
                                  final subject = Uri.encodeComponent(
                                    '${a.practitionerName} • ${formatAppointmentDateLabel(context, a.dateLabel)}',
                                  );
                                  final msg = Uri.encodeComponent(
                                    l10n.appointmentDetailDoctorReportTitle,
                                  );
                                  context.push(
                                    '/messages/new?subject=$subject&message=$msg',
                                  );
                                },
                                leading: const Icon(Icons.mail_rounded),
                                child: Text(
                                    l10n.appointmentDetailSendMessageCta),
                              ),
                              SizedBox(height: AppSpacing.md.h),
                            ],
                            if (!a.isPast) ...[
                              _SectionCard(
                                title:
                                    l10n.appointmentDetailPreparationTitle,
                                subtitle:
                                    l10n.appointmentDetailPreparationSubtitle,
                                children: [
                                  _PrepTile(
                                    icon: Icons.assignment_rounded,
                                    title:
                                        l10n.appointmentDetailPrepQuestionnaire,
                                    statusLabel: l10n.commonTodo,
                                    onTap: () => context.push(
                                      '/appointments/${a.id}/questionnaire',
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSpacing.lg.w,
                                    ),
                                    child: Divider(height: 1.h),
                                  ),
                                  _PrepTile(
                                    icon: Icons.info_outline_rounded,
                                    title:
                                        l10n.appointmentDetailPrepInstructions,
                                    statusLabel: l10n.commonToRead,
                                    onTap: () => context.push(
                                      '/appointments/${a.id}/instructions',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSpacing.md.h),
                              _SectionCard(
                                title:
                                    l10n.appointmentDetailEarlierSlotTitle,
                                subtitle:
                                    l10n.appointmentDetailEarlierSlotSubtitle,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSpacing.xl.w,
                                      vertical: AppSpacing.md.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.appointmentDetailEnableAlerts,
                                          ),
                                        ),
                                        const Switch(
                                          value: false,
                                          onChanged: null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSpacing.lg.h),
                              DokalButton.primary(
                                onPressed: () => context.push('/messages'),
                                leading: const Icon(Icons.mail_rounded),
                                child: Text(
                                    l10n.appointmentDetailContactOffice),
                              ),
                            ],
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
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.w,
              vertical: AppSpacing.md.h,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.brandGradientStart,
                  AppColors.brandGradientEnd,
                ],
              ),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(AppRadii.lg.r)),
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
                    '${formatAppointmentDateLabel(context, a.dateLabel)} • ${a.timeLabel}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _DetailTile(
            icon: Icons.person_rounded,
            title: a.practitionerName,
            subtitle: a.specialty,
            trailing: Icons.chevron_right_rounded,
            onTap: () =>
                context.push('/home/practitioner/${a.practitionerId}'),
          ),
          if (a.reason.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Divider(height: 1.h),
            ),
            _DetailTile(
              icon: Icons.medical_information_rounded,
              title: a.reason,
            ),
          ],
          if (a.address != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Divider(height: 1.h),
            ),
            _DetailTile(
              icon: Icons.location_on_rounded,
              title: a.address!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.a});
  final Appointment a;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DokalCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.sm.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () => RescheduleSheet.show(context, appointment: a),
              icon: Icon(Icons.sync_rounded, size: 16.sp),
              label: Text(
                l10n.appointmentDetailReschedule,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
          Container(width: 1.w, height: 24.h, color: AppColors.outline),
          Expanded(
            child: TextButton.icon(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text(
                        l10n.appointmentDetailCancelQuestion,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      content: Text(
                        l10n.commonActionIsFinal,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: Text(l10n.commonBack),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: Text(l10n.commonCancel),
                        ),
                      ],
                    );
                  },
                );
                if (ok == true && context.mounted) {
                  context.read<AppointmentDetailCubit>().cancel();
                }
              },
              icon: Icon(
                Icons.close_rounded,
                size: 16.sp,
                color: AppColors.error,
              ),
              label: Text(
                l10n.commonCancel,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final IconData? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.xs.h,
      ),
      leading: Icon(icon, color: AppColors.primary, size: 24.sp),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing:
          trailing != null ? Icon(trailing, color: AppColors.textSecondary) : null,
      onTap: onTap,
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
            padding: EdgeInsetsDirectional.fromSTEB(
              AppSpacing.lg.w,
              AppSpacing.lg.h,
              AppSpacing.lg.w,
              AppSpacing.sm.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
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
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String statusLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.xs.h,
      ),
      leading: Icon(icon, color: AppColors.primary, size: 24.sp),
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
      onTap: onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.commonAvailableSoon)),
            );
          },
    );
  }
}
