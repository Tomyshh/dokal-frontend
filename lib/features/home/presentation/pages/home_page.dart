import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/appointment_card.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
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
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _HomeHeader()),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xs.h)),
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
    );
  }
}

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
                  // Salutation + localisation
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetingText,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (hasLocation) ...[
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 14.r,
                                height: 14.r,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.location_on_rounded,
                                  size: 9.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  locationLabel,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                  // Bouton notification
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 22.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  // Avatar utilisateur (cliquable → onglet compte)
                  GestureDetector(
                    onTap: () => context.go('/account'),
                    child: _UserAvatar(
                      avatarUrl: state.avatarUrl,
                      name: displayName,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: AppSpacing.md.h),
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
                border: Border.all(color: AppColors.outline, width: 1.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 16.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                    size: 22.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      l10n.homeSearchHint,
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
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
                      borderRadius: BorderRadius.circular(AppRadii.md.r),
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
            errorWidget: (ctx, url, err) => _InitialsAvatar(initials: initials),
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brandGradientStart, AppColors.brandGradientEnd],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

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
          return _FindAppointmentEmptyState(
            buttonLabel: l10n.homeFindAppointmentCta,
            onTap: () => context.push('/home/search'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasUpcoming || isLoading || hasPast) ...[
              _SectionTitle(title: l10n.homeUpcomingAppointmentsTitle),
              SizedBox(height: AppSpacing.sm.h),
              _UpcomingAppointmentsSection(),
              SizedBox(height: AppSpacing.lg.h),
            ],
            _NewMessageSection(),
            SizedBox(height: AppSpacing.lg.h),
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
      padding: EdgeInsets.only(top: AppSpacing.xl.h, bottom: AppSpacing.lg.h),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96.r,
                height: 96.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_rounded,
                  size: 48.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppSpacing.md.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                child: Text(
                  l10n.homeNoAppointmentsEmptyDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.search_rounded),
                  label: Text(buttonLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg.w,
                      vertical: 14.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.xl.r),
                    ),
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
            padding: EdgeInsets.all(AppSpacing.md.r),
            child: Row(
              children: [
                Icon(
                  Icons.event_available_rounded,
                  color: AppColors.textSecondary,
                  size: 22.sp,
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Text(
                    context.l10n.homeNoUpcomingAppointments,
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

class _UpcomingAppointmentsShimmer extends StatelessWidget {
  const _UpcomingAppointmentsShimmer();

  @override
  Widget build(BuildContext context) {
    final baseColor = AppColors.surfaceVariant;
    final highlightColor = Colors.white.withValues(alpha: 0.9);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: [
          for (var i = 0; i < 2; i++) ...[
            const _AppointmentCardSkeleton(),
            if (i != 1) SizedBox(height: AppSpacing.sm),
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
    final block = AppColors.surfaceVariant;

    return DokalCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _SkBlock(height: 26.h, borderRadius: 8.r, color: block),
              ),
              SizedBox(width: AppSpacing.sm.w),
              _SkBlock(
                height: 26.h,
                width: 72.w,
                borderRadius: 999.r,
                color: block,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              _SkBlock(
                height: 40.r,
                width: 40.r,
                borderRadius: 12.r,
                color: block,
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkBlock(
                      height: 14.h,
                      width: 170.w,
                      borderRadius: 6.r,
                      color: block,
                    ),
                    SizedBox(height: 8.h),
                    _SkBlock(
                      height: 18.h,
                      width: 130.w,
                      borderRadius: 6.r,
                      color: block,
                    ),
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

class _SkBlock extends StatelessWidget {
  const _SkBlock({
    required this.height,
    this.width,
    required this.borderRadius,
    required this.color,
  });

  final double height;
  final double? width;
  final double borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
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
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
          width: 1.r,
        ),
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
        final chipLabel =
            isPast ? l10n.appointmentsTabPast : l10n.appointmentsTabUpcoming;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: l10n.messagesTitle),
            SizedBox(height: AppSpacing.sm.h),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.push('/messages/c/${conv.id}', extra: conv),
              child: DokalCard(
                padding: EdgeInsets.all(AppSpacing.md.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.brandGradientStart,
                            AppColors.brandGradientEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadii.lg.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
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
                                      : AppColors.accent
                                          .withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(999.r),
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
                    SizedBox(width: AppSpacing.xs.w),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20.sp,
                      color: AppColors.primary,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
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
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
              return DokalCard(
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
                        color: AppColors.textSecondary,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
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
