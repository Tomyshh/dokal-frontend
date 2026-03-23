import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_animations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/appointment_card.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_fade_in.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../core/utils/search_filter_utils.dart';
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
          appBar: DokalAppBar(
            title: l10n.appointmentsTitle,
            showBackButton: false,
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(52.h),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg.w,
                  vertical: AppSpacing.xs.h,
                ),
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadii.xl.r),
                  ),
                  child: TabBar(
                    indicatorPadding: EdgeInsets.zero,
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
              ),
            ),
          ),
          body: const TabBarView(
            children: [_UpcomingTab(), _PastTab()],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'fab_appointments',
            onPressed: () => context.push('/home/search'),
            child: Icon(Icons.add_rounded, size: 26.sp),
          ),
        ),
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
                : DokalButton.gold(
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
            return DokalFadeIn(
              delay: AppAnimations.staggerDelayFor(index),
              child: AppointmentCard(
                dateLabel: a.dateLabel,
                timeLabel: a.timeLabel,
                practitionerName: a.practitionerName,
                specialty: specialtyToDisplayLabel(a.specialty, context.l10n),
                reason: a.reason,
                address: a.address,
                status: a.status,
                onTap: () => context.push('/appointments/${a.id}'),
              ),
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
                : DokalButton.gold(
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
            return DokalFadeIn(
              delay: AppAnimations.staggerDelayFor(index),
              child: AppointmentCard(
                dateLabel: a.dateLabel,
                timeLabel: a.timeLabel,
                practitionerName: a.practitionerName,
                specialty: specialtyToDisplayLabel(a.specialty, context.l10n),
                reason: a.reason,
                address: a.address,
                status: a.status,
                onTap: () => context.push('/appointments/${a.id}'),
              ),
            );
          },
        );
      },
    );
  }
}
