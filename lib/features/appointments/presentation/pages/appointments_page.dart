import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/appointment_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../bloc/appointments_cubit.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppointmentsCubit>()..load(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 48,
            title: Text(
              'Mes rendez-vous',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            centerTitle: true,
            bottom: TabBar(
              dividerColor: Colors.transparent,
              labelStyle: Theme.of(context).textTheme.labelLarge,
              unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'À venir'),
                Tab(text: 'Passés'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.small(
            onPressed: () => context.go('/search'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add_rounded, size: 20),
          ),
          body: const TabBarView(
            children: [
              _UpcomingTab(),
              _PastTab(),
            ],
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
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        if (state.status == AppointmentsStatus.loading) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: DokalLoader(lines: 5),
          );
        }
        if (state.status == AppointmentsStatus.failure) {
          return DokalEmptyState(
            title: 'Impossible de charger',
            subtitle: state.error ?? 'Réessayez plus tard.',
            icon: Icons.error_outline_rounded,
          );
        }
        final items = state.upcoming;
        if (items.isEmpty) {
          return const DokalEmptyState(
            title: 'Aucun rendez-vous à venir',
            subtitle: 'Vos prochains RDV apparaîtront ici.',
            icon: Icons.event_available_rounded,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: items.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final a = items[index];
            return AppointmentCard(
              dateLabel: a.dateLabel,
              timeLabel: a.timeLabel,
              practitionerName: a.practitionerName,
              specialty: a.specialty,
              reason: a.reason,
              onTap: () => context.go('/appointments/${a.id}'),
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
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        if (state.status == AppointmentsStatus.loading) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: DokalLoader(lines: 5),
          );
        }
        if (state.status == AppointmentsStatus.failure) {
          return DokalEmptyState(
            title: 'Impossible de charger',
            subtitle: state.error ?? 'Réessayez plus tard.',
            icon: Icons.error_outline_rounded,
          );
        }
        final items = state.past;
        if (items.isEmpty) {
          return const DokalEmptyState(
            title: 'Aucun rendez-vous passé',
            subtitle: 'Vos RDV terminés apparaîtront ici.',
            icon: Icons.event_busy_rounded,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: items.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final a = items[index];
            return AppointmentCard(
              dateLabel: a.dateLabel,
              timeLabel: a.timeLabel,
              practitionerName: a.practitionerName,
              specialty: a.specialty,
              reason: a.reason,
              onTap: () => context.go('/appointments/${a.id}'),
            );
          },
        );
      },
    );
  }
}

