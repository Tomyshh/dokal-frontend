import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/appointment_card.dart';
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
          appBar: AppBar(
            toolbarHeight: 48.h,
            title: Text(
              l10n.appointmentsTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            bottom: TabBar(
              dividerColor: Colors.transparent,
              labelStyle: Theme.of(context).textTheme.labelLarge,
              unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: l10n.appointmentsTabUpcoming),
                Tab(text: l10n.appointmentsTabPast),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'fab_appointments',
            onPressed: () => context.push('/home/search'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add_rounded, size: 20),
          ),
          body: const TabBarView(children: [_UpcomingTab(), _PastTab()]),
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
            subtitle: l10n.appointmentsNoUpcomingSubtitle,
            icon: Icons.event_available_rounded,
          );
        }
        return ListView.separated(
          padding: EdgeInsets.all(AppSpacing.lg.r),
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
            subtitle: l10n.appointmentsNoPastSubtitle,
            icon: Icons.event_busy_rounded,
          );
        }
        return ListView.separated(
          padding: EdgeInsets.all(AppSpacing.lg.r),
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
