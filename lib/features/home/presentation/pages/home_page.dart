import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_animations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/appointment_card.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_fade_in.dart';
import '../../../../core/widgets/dokal_section_title.dart';
import '../../../../core/widgets/dokal_shimmer_block.dart';
import '../../../../injection_container.dart';
import '../../../../core/utils/search_filter_utils.dart';
import '../../../../l10n/l10n.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>(),
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, n) => p.isAuthenticated != n.isAuthenticated,
        listener: (context, _) => context.read<HomeCubit>().load(),
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  context.read<HomeCubit>().load();
                  await Future.delayed(AppAnimations.slow);
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _HomeHeader()),
                    SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm.h)),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          SizedBox(height: AppSpacing.sm.h),
                          _AppointmentsSections(),
                          SizedBox(height: 100.h),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HOME HEADER
// ═══════════════════════════════════════════════════════════════════════════════

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.md.h,
        AppSpacing.lg.w,
        AppSpacing.xs.h,
      ),
      child: Column(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (p, n) =>
                p.greetingName != n.greetingName ||
                p.avatarUrl != n.avatarUrl ||
                p.city != n.city ||
                p.country != n.country ||
                p.status != n.status,
            builder: (context, state) {
              final isAuthed = context.read<AuthBloc>().state.isAuthenticated;
              final name = state.greetingName;
              final hasName = isAuthed && name.trim().isNotEmpty;
              final greetingText = hasName
                  ? l10n.homeGreeting(name)
                  : l10n.homeGreetingGuest;
              final displayName = hasName ? name : '?';
              final city = state.city ?? '';
              final country = state.country ?? '';
              final hasLocation = city.isNotEmpty || country.isNotEmpty;
              final locationLabel = [city, country]
                  .where((s) => s.isNotEmpty)
                  .join(', ');

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetingText,
                          style: AppTextStyles.headingMd(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (hasLocation) ...[
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16.r,
                                height: 16.r,
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.location_on_rounded,
                                  size: 10.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  locationLabel,
                                  style: AppTextStyles.bodyXs(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (p, n) => p.isAuthenticated != n.isAuthenticated,
                    builder: (context, authState) {
                      if (authState.isAuthenticated) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _IconCircle(
                              icon: Icons.notifications_none_rounded,
                              onTap: () {},
                            ),
                            SizedBox(width: AppSpacing.sm.w),
                            GestureDetector(
                              onTap: () => context.go('/account'),
                              child: _UserAvatar(
                                avatarUrl: state.avatarUrl,
                                name: displayName,
                              ),
                            ),
                          ],
                        );
                      }
                      return GestureDetector(
                        onTap: () => context.go('/account'),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.brandGradient,
                            borderRadius:
                                BorderRadius.circular(AppRadii.pill.r),
                            boxShadow: AppShadows.primaryGlow,
                          ),
                          child: Text(
                            l10n.authLoginButton,
                            style: AppTextStyles.labelMd(
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          SizedBox(height: AppSpacing.md.h),
          // ── Search bar ──────────────────────────────────────────────
          GestureDetector(
            onTap: () => context.push('/home/search'),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.xl.r),
                border: Border.all(color: AppColors.outline),
                boxShadow: AppShadows.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: AppColors.textTertiary,
                    size: 22.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      l10n.homeSearchHint,
                      style: AppTextStyles.bodyMd(color: AppColors.textTertiary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(AppRadii.lg.r),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SMALL REUSABLE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22.sp, color: AppColors.textSecondary),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.avatarUrl, required this.name});

  final String? avatarUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = _extractInitials(name);

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 10.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: avatarUrl!,
            fit: BoxFit.cover,
            width: 44.r,
            height: 44.r,
            errorWidget: (ctx, url, err) =>
                _InitialsAvatar(initials: initials),
            placeholder: (ctx, url) => _InitialsAvatar(initials: initials),
          ),
        ),
      );
    }

    return _InitialsAvatar(initials: initials);
  }

  static String _extractInitials(String name) {
    if (name.trim().isEmpty || name == '...') return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0].characters.first}${parts[1].characters.first}'
          .toUpperCase();
    }
    return parts[0].characters.take(2).toString().toUpperCase();
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        shape: BoxShape.circle,
        boxShadow: AppShadows.primaryGlow,
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.labelMd(color: AppColors.textOnPrimary),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// APPOINTMENTS SECTIONS
// ═══════════════════════════════════════════════════════════════════════════════

class _AppointmentsSections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (p, n) =>
          p.status != n.status ||
          p.upcomingAppointments != n.upcomingAppointments ||
          p.appointmentHistory != n.appointmentHistory,
      builder: (context, state) {
        final isLoading =
            state.status == HomeStatus.initial ||
            state.status == HomeStatus.loading;
        final hasUpcoming = state.upcomingAppointments.isNotEmpty;
        final hasPast = state.appointmentHistory.isNotEmpty;

        final showFindAppointmentCta =
            state.status == HomeStatus.success && !hasUpcoming && !hasPast;

        if (showFindAppointmentCta) {
          return DokalFadeIn(
            child: _FindAppointmentEmptyState(
              buttonLabel: l10n.homeFindAppointmentCta,
              onTap: () => context.push('/home/search'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasUpcoming || isLoading || hasPast) ...[
              DokalFadeIn(
                child: DokalSectionTitle(
                  title: l10n.homeUpcomingAppointmentsTitle,
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),
              _UpcomingAppointmentsSection(),
              SizedBox(height: AppSpacing.xl.h),
            ],
            _NewMessageSection(),
            SizedBox(height: AppSpacing.xl.h),
            _AppointmentHistorySection(),
          ],
        );
      },
    );
  }
}

class _FindAppointmentEmptyState extends StatelessWidget {
  const _FindAppointmentEmptyState({
    required this.buttonLabel,
    required this.onTap,
  });

  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xxl.h, bottom: AppSpacing.lg.h),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88.r,
                height: 88.r,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_rounded,
                  size: 42.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                child: Text(
                  l10n.homeNoAppointmentsEmptyDescription,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySm(),
                ),
              ),
              SizedBox(height: AppSpacing.xl.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.search_rounded),
                  label: Text(buttonLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg.w,
                      vertical: 14.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.lg.r),
                    ),
                    textStyle: AppTextStyles.labelMd(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// UPCOMING APPOINTMENTS
// ═══════════════════════════════════════════════════════════════════════════════

class _UpcomingAppointmentsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (p, n) =>
          p.upcomingAppointments != n.upcomingAppointments ||
          p.greetingName != n.greetingName ||
          p.status != n.status,
      builder: (context, state) {
        final items = state.upcomingAppointments;
        if ((state.status == HomeStatus.initial ||
                state.status == HomeStatus.loading) &&
            items.isEmpty) {
          return const _UpcomingAppointmentsShimmer();
        }
        if (items.isEmpty) {
          return DokalCard(
            variant: DokalCardVariant.filled,
            padding: EdgeInsets.all(AppSpacing.md.r),
            child: Row(
              children: [
                Icon(
                  Icons.event_available_rounded,
                  color: AppColors.textTertiary,
                  size: 22.sp,
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Text(
                    context.l10n.homeNoUpcomingAppointments,
                    style: AppTextStyles.bodySm(),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              DokalFadeIn(
                delay: AppAnimations.staggerDelayFor(i),
                child: AppointmentCard(
                  dateLabel: items[i].dateLabel,
                  timeLabel: items[i].timeLabel,
                  practitionerName: items[i].practitionerName,
                  specialty: specialtyToDisplayLabel(
                    items[i].specialty,
                    context.l10n,
                  ),
                  reason: items[i].reason,
                  address: items[i].address,
                  avatarUrl: items[i].avatarUrl,
                  isPast: items[i].isPast,
                  status: items[i].status,
                  trailing: _PatientChip(
                    name: items[i].patientName ?? state.greetingName,
                  ),
                  onTap: () => context.push('/appointments/${items[i].id}'),
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),
            ],
          ],
        );
      },
    );
  }
}

class _UpcomingAppointmentsShimmer extends StatelessWidget {
  const _UpcomingAppointmentsShimmer();

  @override
  Widget build(BuildContext context) {
    return DokalShimmerGroup(
      child: Column(
        children: [
          for (var i = 0; i < 2; i++) ...[
            const _AppointmentCardSkeleton(),
            if (i != 1) SizedBox(height: AppSpacing.sm.h),
          ],
        ],
      ),
    );
  }
}

class _AppointmentCardSkeleton extends StatelessWidget {
  const _AppointmentCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return DokalCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DokalShimmerBlock(height: 26.h, borderRadius: 8),
              ),
              SizedBox(width: AppSpacing.sm.w),
              DokalShimmerBlock(
                height: 26.h,
                width: 72.w,
                borderRadius: AppRadii.pill,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              DokalShimmerBlock.circle(size: 40.r),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DokalShimmerBlock(height: 14.h, width: 170.w),
                    SizedBox(height: 8.h),
                    DokalShimmerBlock(height: 18.h, width: 130.w),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppRadii.pill.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.20),
        ),
      ),
      child: Text(
        name,
        style: AppTextStyles.labelXs(color: AppColors.primary),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// NEW MESSAGES
// ═══════════════════════════════════════════════════════════════════════════════

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
        final chipLabel =
            isPast ? l10n.appointmentsTabPast : l10n.appointmentsTabUpcoming;
        final isRtl = Directionality.of(context) == TextDirection.rtl;

        return DokalFadeIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DokalSectionTitle(title: l10n.messagesTitle),
              SizedBox(height: AppSpacing.sm.h),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    context.push('/messages/c/${conv.id}', extra: conv),
                child: DokalCard(
                  padding: EdgeInsets.all(AppSpacing.md.r),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: BorderRadius.circular(AppRadii.lg.r),
                          boxShadow: AppShadows.primaryGlow,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.mail_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                            Positioned(
                              right: 4.w,
                              top: 4.h,
                              child: Container(
                                width: 10.r,
                                height: 10.r,
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.r,
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
                              style: AppTextStyles.titleSm(),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              conv.lastMessage,
                              style: AppTextStyles.bodyXs(),
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
                                        ? AppColors.surfaceVariant
                                        : AppColors.successLight,
                                    borderRadius:
                                        BorderRadius.circular(AppRadii.pill.r),
                                  ),
                                  child: Text(
                                    chipLabel,
                                    style: AppTextStyles.labelXs(
                                      color: isPast
                                          ? AppColors.textSecondary
                                          : AppColors.success,
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppSpacing.sm.w),
                                Expanded(
                                  child: Text(
                                    apptLabel,
                                    style: AppTextStyles.labelXs(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs.w),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Icon(
                          isRtl
                              ? Icons.chevron_left_rounded
                              : Icons.chevron_right_rounded,
                          size: 20.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// APPOINTMENT HISTORY
// ═══════════════════════════════════════════════════════════════════════════════

class _AppointmentHistorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DokalSectionTitle(
          title: l10n.homeLast3AppointmentsTitle,
          actionLabel: l10n.homeSeeAllPastAppointments,
          onAction: () => context.go('/appointments?tab=past'),
        ),
        SizedBox(height: AppSpacing.sm.h),
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (p, n) => p.appointmentHistory != n.appointmentHistory,
          builder: (context, state) {
            final items = state.appointmentHistory;
            if (items.isEmpty) {
              return DokalCard(
                variant: DokalCardVariant.filled,
                padding: EdgeInsets.all(AppSpacing.md.r),
                child: Row(
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadii.lg.r),
                      ),
                      child: Icon(
                        Icons.event_busy_rounded,
                        color: AppColors.textTertiary,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: Text(
                        l10n.homeNoAppointmentHistory,
                        style: AppTextStyles.bodySm(),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(i),
                    child: AppointmentCard(
                      dateLabel: items[i].dateLabel,
                      timeLabel: items[i].timeLabel,
                      practitionerName: items[i].practitionerName,
                      specialty: specialtyToDisplayLabel(
                        items[i].specialty,
                        l10n,
                      ),
                      reason: items[i].reason,
                      address: items[i].address,
                      avatarUrl: items[i].avatarUrl,
                      isPast: items[i].isPast,
                      status: items[i].status,
                      trailing: _PatientChip(
                        name: items[i].patientName ?? l10n.commonMe,
                      ),
                      onTap: () =>
                          context.push('/appointments/${items[i].id}'),
                    ),
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
