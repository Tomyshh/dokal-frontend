import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/appointment_card.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<HomeCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // Header avec gradient bleu - sticky au top
            const _StickyHeader(),
            // Contenu
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: AppSpacing.md.h),
                  // Card profil santé (tout en haut)
                  _HealthProfileCard(),
                  SizedBox(height: AppSpacing.md.h),
                  // Rendez-vous à venir
                  _SectionTitle(title: l10n.homeUpcomingAppointmentsTitle),
                  SizedBox(height: AppSpacing.xs.h),
                  _UpcomingAppointmentsSection(),
                  SizedBox(height: AppSpacing.md.h),
                  // Nouveau message (3e position)
                  _NewMessageSection(),
                  SizedBox(height: AppSpacing.lg.h),
                  // 3 derniers rendez-vous + CTA
                  _AppointmentHistorySection(),
                  const SizedBox(height: 100), // Espace pour la navbar
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingAppointmentsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (p, n) =>
          p.upcomingAppointments != n.upcomingAppointments ||
          p.greetingName != n.greetingName,
      builder: (context, state) {
        final items = state.upcomingAppointments;
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            for (final a in items) ...[
              AppointmentCard(
                dateLabel: a.dateLabel,
                timeLabel: a.timeLabel,
                practitionerName: a.practitionerName,
                specialty: a.specialty,
                reason: a.reason,
                avatarUrl: a.avatarUrl,
                isPast: a.isPast,
                trailing: _PatientChip(
                  name: a.patientName ?? state.greetingName,
                ),
                onTap: () => context.push('/appointments/${a.id}'),
              ),
              SizedBox(height: AppSpacing.sm.h),
            ],
          ],
        );
      },
    );
  }
}

class _PatientChip extends StatelessWidget {
  const _PatientChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Text(
        name,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NewMessageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (p, n) => p.newMessageConversation != n.newMessageConversation,
      builder: (context, state) {
        final conv = state.newMessageConversation;
        if (conv == null) return const SizedBox.shrink();

        final appt = conv.appointment;
        final apptLabel = appt == null
            ? l10n.homeNewMessageNoAppointment
            : '${appt.title} • ${appt.date}';

        final isPast = appt?.isPast ?? false;
        final chipLabel = isPast
            ? l10n.appointmentsTabPast
            : l10n.appointmentsTabUpcoming;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: l10n.messagesTitle),
            SizedBox(height: AppSpacing.xs.h),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.push('/messages/c/${conv.id}'),
              child: Container(
                padding: EdgeInsets.all(AppSpacing.md.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryLightBackground,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icône message avec badge
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primaryLight,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8.r,
                            offset: Offset(0, 3.h),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.mail_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                          // Badge notification
                          Positioned(
                            right: 4.w,
                            top: 4.h,
                            child: Container(
                              width: 12.r,
                              height: 12.r,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.homeNewMessageTitle(conv.name),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            conv.lastMessage,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isPast
                                      ? AppColors.textSecondary
                                          .withValues(alpha: 0.1)
                                      : AppColors.accent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(999.r),
                                  border: Border.all(
                                    color: isPast
                                        ? AppColors.textSecondary
                                            .withValues(alpha: 0.2)
                                        : AppColors.accent
                                            .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  chipLabel,
                                  style: TextStyle(
                                    color: isPast
                                        ? AppColors.textSecondary
                                        : AppColors.accent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSpacing.sm.w),
                              Expanded(
                                child: Text(
                                  apptLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 20.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Header sticky utilisant SliverAppBar
class _StickyHeader extends StatelessWidget {
  const _StickyHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 140,
      collapsedHeight: 140,
      toolbarHeight: 140,
      backgroundColor: const Color(0xFF005044),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF005044), Color(0xFF003D33)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg.w,
              AppSpacing.sm.h,
              AppSpacing.lg.w,
              AppSpacing.md.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Salutation
                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (p, n) =>
                      p.greetingName != n.greetingName || p.status != n.status,
                  builder: (context, state) {
                    final name = state.greetingName;
                    return Text(
                      l10n.homeGreeting(name),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                SizedBox(height: AppSpacing.md.h),
                // Barre de recherche - padding vertical au lieu de hauteur fixe
                GestureDetector(
                  onTap: () => context.push('/home/search'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 16.r,
                          spreadRadius: 0,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: AppColors.textSecondary.withValues(alpha: 0.6),
                          size: 22.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            l10n.homeSearchHint,
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 36.r,
                          height: 36.r,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLightBackground,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Card profil santé - design compact
class _HealthProfileCard extends StatefulWidget {
  @override
  State<_HealthProfileCard> createState() => _HealthProfileCardState();
}

class _HealthProfileCardState extends State<_HealthProfileCard> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (!_isVisible) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: AppColors.primaryLightBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenu texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.homeCompleteHealthProfile,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isVisible = false),
                      child: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  l10n.homeCompleteHealthProfileSubtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                _CompactButton(
                  label: l10n.homeStart,
                  onTap: () => context.push('/home/health-profile'),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          // Icône coeur
          _HeartPulseIcon(),
        ],
      ),
    );
  }
}

/// Bouton compact stylisé
class _CompactButton extends StatelessWidget {
  const _CompactButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Icône coeur avec pulse
class _HeartPulseIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.favorite, color: Colors.pinkAccent, size: 28),
          Positioned(
            right: 2,
            bottom: 6,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.show_chart,
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Titre de section
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }
}

class _AppointmentHistorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _SectionTitle(title: l10n.homeLast3AppointmentsTitle),
            ),
            TextButton(
              onPressed: () => context.go('/appointments?tab=past'),
              child: Text(l10n.homeSeeAllPastAppointments),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs.h),
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (p, n) => p.appointmentHistory != n.appointmentHistory,
          builder: (context, state) {
            final items = state.appointmentHistory;
            if (items.isEmpty) {
              return Container(
                padding: EdgeInsets.all(AppSpacing.md.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryLightBackground,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.event_busy_rounded,
                        color: AppColors.textSecondary,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    Expanded(
                      child: Text(
                        l10n.homeNoAppointmentHistory,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                for (final a in items) ...[
                  AppointmentCard(
                    dateLabel: a.dateLabel,
                    timeLabel: a.timeLabel,
                    practitionerName: a.practitionerName,
                    specialty: a.specialty,
                    reason: a.reason,
                    avatarUrl: a.avatarUrl,
                    isPast: a.isPast,
                    trailing: _PatientChip(
                      name: a.patientName ?? l10n.commonMe,
                    ),
                    onTap: () => context.push('/appointments/${a.id}'),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
