import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/search_filter_utils.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
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

  static const _stepPaths = [
    '/booking/:id/reason',
    '/booking/:id/patient',
    '/booking/:id/instructions',
    '/booking/:id/slot',
    '/booking/:id/confirm',
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final prefs = sl<SharedPreferences>();
            return BookingBloc(
              practitionerId: practitionerId,
              initialAddressLine: prefs.getString('patient_address_line'),
              initialZipCode: prefs.getString('patient_zip_code'),
              initialCity: prefs.getString('patient_city'),
            );
          },
        ),
        BlocProvider(
          create: (_) => sl<PractitionerCubit>(param1: practitionerId),
        ),
      ],
      child: Builder(
        builder: (context) {
          final location = GoRouterState.of(context).matchedLocation;
          final idx = _stepIndexFromLocation(location);

          final l10n = context.l10n;
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.textPrimary,
              surfaceTintColor: Colors.transparent,
              scrolledUnderElevation: 0,
              elevation: 0,
              title: BlocBuilder<PractitionerCubit, PractitionerState>(
                builder: (context, pState) {
                  final name = pState.profile?.name ?? l10n.commonFallbackDash;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.bookingFlowTitle,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  );
                },
              ),
              leading: IconButton(
                icon: Icon(
                  isRtl
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  size: 18.sp,
                ),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home/practitioner/$practitionerId');
                  }
                },
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg.w,
                      AppSpacing.sm.h,
                      AppSpacing.lg.w,
                      AppSpacing.sm.h,
                    ),
                    child: Column(
                      children: [
                        _StepIndicator(current: idx, total: _stepPaths.length),
                        SizedBox(height: AppSpacing.md.h),
                        BlocBuilder<BookingBloc, BookingState>(
                          builder: (context, state) {
                            return DokalCard(
                              padding: EdgeInsets.all(AppSpacing.md.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 42.r,
                                        height: 42.r,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              AppColors.brandGradientStart,
                                              AppColors.brandGradientEnd,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            AppRadii.lg.r,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.medical_services_rounded,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                      SizedBox(width: AppSpacing.md.w),
                                      Expanded(
                                        child: BlocBuilder<PractitionerCubit,
                                            PractitionerState>(
                                          builder: (context, pState) {
                                            final p = pState.profile;
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  p?.name ?? l10n.commonFallbackDash,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  '${specialtyToDisplayLabel(p?.specialty, l10n)} • ${p?.address ?? l10n.commonFallbackDash}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: AppSpacing.sm.h),
                                  Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.h,
                                    children: [
                                      _SummaryPill(
                                        icon:
                                            Icons.medical_information_rounded,
                                        label: state.reason ?? l10n.bookingStepReason,
                                        isActive: state.reason != null,
                                      ),
                                      _SummaryPill(
                                        icon: Icons.person_rounded,
                                        label:
                                            state.patientLabel ?? l10n.bookingStepPatient,
                                        isActive:
                                            state.patientLabel != null,
                                      ),
                                      _SummaryPill(
                                        icon: Icons.info_rounded,
                                        label: state.instructionsAccepted
                                            ? l10n.bookingStepInstructionsOk
                                            : l10n.bookingStepInstructions,
                                        isActive:
                                            state.instructionsAccepted,
                                      ),
                                      _SummaryPill(
                                        icon: Icons.schedule_rounded,
                                        label:
                                            state.slotLabel ?? l10n.bookingStepSlot,
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
                  Divider(height: 1.h),
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

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final isCompleted = i <= current;
        return Expanded(
          child: Container(
            margin: EdgeInsetsDirectional.only(
              end: i < total - 1 ? 4.w : 0,
            ),
            height: 4.h,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.primary
                  : AppColors.outline,
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
        );
      }),
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
        : AppColors.surfaceVariant;
    final fg = isActive ? AppColors.accent : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: isActive
              ? AppColors.accent.withValues(alpha: 0.22)
              : AppColors.outline,
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: fg),
          SizedBox(width: 6.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 160.w),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: fg, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

