import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/appointment_card.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/appointments_cubit.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tab = GoRouterState.of(context).uri.queryParameters['tab'];
    final initialIndex = tab == 'past' ? 1 : 0;
    return BlocProvider(
      create: (_) => sl<AppointmentsCubit>()..load(),
      child: DefaultTabController(
        length: 2,
        initialIndex: initialIndex,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              _AppointmentsHeader(l10n: l10n),
              Expanded(
                child: const TabBarView(
                  children: [_UpcomingTab(), _PastTab()],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'fab_appointments',
            onPressed: () => context.push('/home/search'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: const CircleBorder(),
            child: Icon(Icons.add_rounded, size: 26.sp),
          ),
        ),
      ),
    );
  }
}

class _AppointmentsHeader extends StatelessWidget {
  const _AppointmentsHeader({required this.l10n});

  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg.w,
              MediaQuery.paddingOf(context).top + AppSpacing.md.h,
              AppSpacing.lg.w,
              AppSpacing.sm.h,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.appointmentsTitle,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.w,
              vertical: AppSpacing.xs.h,
            ),
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadii.xl.r),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadii.lg.r),
              ),
              indicatorPadding: EdgeInsets.zero,
              splashBorderRadius: BorderRadius.circular(AppRadii.lg.r),
              tabs: [
                Tab(
                  height: 36.h,
                  text: l10n.appointmentsTabUpcoming,
                ),
                Tab(
                  height: 36.h,
                  text: l10n.appointmentsTabPast,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
        ],
      ),
    );
  }
}

class _UpcomingTab extends StatelessWidget {
  const _UpcomingTab();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        final hasSession =
            Supabase.instance.client.auth.currentSession != null;
        if (state.status == AppointmentsStatus.loading) {
          return Padding(
            padding: EdgeInsets.all(AppSpacing.lg.r),
            child: const DokalLoader(lines: 5),
          );
        }
        if (state.status == AppointmentsStatus.failure) {
          return DokalEmptyState(
            title: l10n.commonUnableToLoad,
            subtitle: state.error ?? l10n.commonTryAgainLater,
            icon: Icons.error_outline_rounded,
          );
        }
        final items = state.upcoming;
        if (items.isEmpty) {
          return DokalEmptyState(
            title: l10n.appointmentsNoUpcomingTitle,
            subtitle: hasSession
                ? l10n.appointmentsNoUpcomingSubtitle
                : '${l10n.appointmentsNoUpcomingSubtitle}\n${l10n.authLoginSubtitle}',
            icon: Icons.event_available_rounded,
            action: hasSession
                ? null
                : DokalButton.primary(
                    onPressed: () => context.go('/account'),
                    leading: const Icon(Icons.login_rounded),
                    child: Text(l10n.authLoginButton),
                  ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg.w,
            AppSpacing.lg.h,
            AppSpacing.lg.w,
            AppSpacing.lg.h + 100.h,
          ),
          itemCount: items.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: AppSpacing.sm.h),
          itemBuilder: (context, index) {
            final a = items[index];
            return AppointmentCard(
              dateLabel: a.dateLabel,
              timeLabel: a.timeLabel,
              practitionerName: a.practitionerName,
              specialty: a.specialty,
              reason: a.reason,
              onTap: () => context.push('/appointments/${a.id}'),
            );
          },
        );
      },
    );
  }
}

class _PastTab extends StatelessWidget {
  const _PastTab();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        final hasSession =
            Supabase.instance.client.auth.currentSession != null;
        if (state.status == AppointmentsStatus.loading) {
          return Padding(
            padding: EdgeInsets.all(AppSpacing.lg.r),
            child: const DokalLoader(lines: 5),
          );
        }
        if (state.status == AppointmentsStatus.failure) {
          return DokalEmptyState(
            title: l10n.commonUnableToLoad,
            subtitle: state.error ?? l10n.commonTryAgainLater,
            icon: Icons.error_outline_rounded,
          );
        }
        final items = state.past;
        if (items.isEmpty) {
          return DokalEmptyState(
            title: l10n.appointmentsNoPastTitle,
            subtitle: hasSession
                ? l10n.appointmentsNoPastSubtitle
                : '${l10n.appointmentsNoPastSubtitle}\n${l10n.authLoginSubtitle}',
            icon: Icons.event_busy_rounded,
            action: hasSession
                ? null
                : DokalButton.primary(
                    onPressed: () => context.go('/account'),
                    leading: const Icon(Icons.login_rounded),
                    child: Text(l10n.authLoginButton),
                  ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg.w,
            AppSpacing.lg.h,
            AppSpacing.lg.w,
            AppSpacing.lg.h + 100.h,
          ),
          itemCount: items.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: AppSpacing.sm.h),
          itemBuilder: (context, index) {
            final a = items[index];
            return AppointmentCard(
              dateLabel: a.dateLabel,
              timeLabel: a.timeLabel,
              practitionerName: a.practitionerName,
              specialty: a.specialty,
              reason: a.reason,
              onTap: () => context.push('/appointments/${a.id}'),
            );
          },
        );
      },
    );
  }
}
