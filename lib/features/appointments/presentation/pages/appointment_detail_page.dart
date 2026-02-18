import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/appointment.dart';
import '../bloc/appointment_detail_cubit.dart';

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
                  icon: const Icon(Icons.share_rounded, size: 20),
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
                          DokalCard(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm.w,
                              vertical: AppSpacing.xs.h,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () =>
                                        context.push('/home/search'),
                                    icon: Icon(Icons.sync_rounded, size: 16.sp),
                                    label: Text(
                                      l10n.appointmentDetailReschedule,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1.w,
                                  height: 24.h,
                                  color: AppColors.outline,
                                ),
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () async {
                                      final ok = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title: Text(
                                              l10n.appointmentDetailCancelQuestion,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                            content: Text(
                                              l10n.commonActionIsFinal,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(
                                                  ctx,
                                                ).pop(false),
                                                child: Text(l10n.commonBack),
                                              ),
                                              FilledButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx).pop(true),
                                                child: Text(l10n.commonCancel),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (ok == true && context.mounted) {
                                        context
                                            .read<AppointmentDetailCubit>()
                                            .cancel();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: 16.sp,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      l10n.commonCancel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ] else ...[
                          _SectionCard(
                            title: l10n.appointmentDetailVisitSummaryTitle,
                            subtitle:
                                l10n.appointmentDetailVisitSummarySubtitle,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  AppSpacing.lg.w,
                                  0,
                                  AppSpacing.lg.w,
                                  AppSpacing.lg.h,
                                ),
                                child: Text(
                                  l10n.appointmentDetailVisitSummaryDemo,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.md.h),
                          _SectionCard(
                            title: l10n.appointmentDetailDoctorReportTitle,
                            subtitle:
                                l10n.appointmentDetailDoctorReportSubtitle,
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.description_rounded,
                                  color: AppColors.primary,
                                ),
                                title: Text(
                                  l10n.appointmentDetailOpenVisitReport,
                                ),
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
                            title: l10n.appointmentDetailDocumentsAndRxTitle,
                            subtitle:
                                l10n.appointmentDetailDocumentsAndRxSubtitle,
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: AppColors.primary,
                                ),
                                title: Text(
                                  l10n.appointmentDetailOpenPrescription,
                                ),
                                onTap: () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.commonAvailableSoon),
                                      ),
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.lg.h),
                          DokalButton.primary(
                            onPressed: () {
                              final subject = Uri.encodeComponent(
                                '${a.practitionerName} • ${a.dateLabel}',
                              );
                              final msg = Uri.encodeComponent(
                                l10n.appointmentDetailDoctorReportTitle,
                              );
                              context.push(
                                '/messages/new?subject=$subject&message=$msg',
                              );
                            },
                            leading: const Icon(Icons.mail_rounded),
                            child: Text(l10n.appointmentDetailSendMessageCta),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],
                        if (!a.isPast) ...[
                          _SectionCard(
                            title: l10n.appointmentDetailPreparationTitle,
                            subtitle: l10n.appointmentDetailPreparationSubtitle,
                            children: [
                              _PrepTile(
                                icon: Icons.assignment_rounded,
                                title: l10n.appointmentDetailPrepQuestionnaire,
                                statusLabel: l10n.commonTodo,
                                onTap: () => context.push(
                                  '/appointments/${a.id}/questionnaire',
                                ),
                              ),
                              const Divider(height: 1),
                              _PrepTile(
                                icon: Icons.info_outline_rounded,
                                title: l10n.appointmentDetailPrepInstructions,
                                statusLabel: l10n.commonToRead,
                                onTap: () => context.push(
                                  '/appointments/${a.id}/instructions',
                                ),
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
                                    Expanded(
                                      child: Text(
                                        l10n.appointmentDetailEnableAlerts,
                                      ),
                                    ),
                                    const Switch(value: false, onChanged: null),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.lg.h),
                          DokalButton.primary(
                            onPressed: () => context.push('/messages/c/demo1'),
                            leading: const Icon(Icons.mail_rounded),
                            child: Text(l10n.appointmentDetailContactOffice),
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
                    '${a.dateLabel} • ${a.timeLabel}',
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
            title: Text(a.practitionerName),
            subtitle: Text(a.specialty),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/home/practitioner/${a.practitionerId}'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.medical_information_rounded),
            title: Text(a.reason),
          ),
          if (a.address != null) ...[
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.location_on_rounded),
              title: Text(a.address!),
            ),
          ],
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
      onTap:
          onTap ??
          () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.commonAvailableSoon)));
          },
    );
  }
}
