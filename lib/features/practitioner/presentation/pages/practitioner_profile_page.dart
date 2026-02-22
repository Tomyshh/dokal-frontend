import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/format_appointment_date.dart';
import '../../../../core/utils/format_time_slot.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../../appointments/domain/entities/appointment.dart';
import '../../../appointments/domain/usecases/get_past_appointments.dart';
import '../../../appointments/domain/usecases/get_upcoming_appointments.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/practitioner_profile.dart';
import '../../domain/usecases/get_practitioner_reviews.dart';
import '../../domain/usecases/get_practitioner_slots.dart';
import '../../../booking/presentation/widgets/quick_booking_sheet.dart';
import '../bloc/practitioner_cubit.dart';

String _addMinutesToTime(String time, int minutes) {
  final parts = time.split(':');
  if (parts.length < 2) return time;
  var h = int.tryParse(parts[0]) ?? 0;
  var m = int.tryParse(parts[1]) ?? 0;
  m += minutes;
  h += m ~/ 60;
  m = m % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

class PractitionerProfilePage extends StatelessWidget {
  const PractitionerProfilePage({super.key, required this.practitionerId});

  final String practitionerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PractitionerCubit>(param1: practitionerId),
      child: BlocBuilder<PractitionerCubit, PractitionerState>(
        builder: (context, state) {
          final PractitionerProfile? p = state.profile;

          if (state.status == PractitionerStatus.loading) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
              ),
              body: Padding(
                padding: EdgeInsets.all(AppSpacing.lg.r),
                child: const DokalLoader(lines: 7),
              ),
            );
          }

          if (state.status == PractitionerStatus.failure) {
            final l10n = context.l10n;
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
              ),
              body: DokalEmptyState(
                title: l10n.practitionerUnavailableTitle,
                subtitle: state.error ?? l10n.commonTryAgainLater,
                icon: Icons.person_off_rounded,
              ),
            );
          }

          if (p == null) {
            final l10n = context.l10n;
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
              ),
              body: DokalEmptyState(
                title: l10n.practitionerNotFoundTitle,
                subtitle: l10n.practitionerNotFoundSubtitle,
                icon: Icons.person_off_rounded,
              ),
            );
          }

          return _ProfileScaffold(profile: p, practitionerId: practitionerId);
        },
      ),
    );
  }
}

class _ProfileScaffold extends StatefulWidget {
  const _ProfileScaffold({required this.profile, required this.practitionerId});

  final PractitionerProfile profile;
  final String practitionerId;

  @override
  State<_ProfileScaffold> createState() => _ProfileScaffoldState();
}

class _ProfileScaffoldState extends State<_ProfileScaffold> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _timeSlotSectionKey = GlobalKey();
  bool _showTitleInAppBar = false;
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _selectedEndTime;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > 180.h;
    if (shouldShow != _showTitleInAppBar) {
      setState(() => _showTitleInAppBar = shouldShow);
    }
  }

  String _getInitials() {
    final parts = widget.profile.name
        .replaceAll('ד"ר ', '')
        .replaceAll('Dr. ', '')
        .split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0];
    }
    return '?';
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedTime = null;
      _selectedEndTime = null;
    });
    // Scroll automatique vers le choix de l'heure après l'animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 350), () {
        if (!mounted) return;
        final ctx = _timeSlotSectionKey.currentContext;
        if (ctx != null && ctx.mounted) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.1,
          );
        }
      });
    });
  }

  void _onSlotSelected(({String start, String end}) slot) {
    setState(() {
      _selectedTime = slot.start;
      _selectedEndTime = slot.end;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final bool canBook = _selectedDate != null && _selectedTime != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // SliverAppBar avec avatar et nom quand on scroll
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            pinned: true,
            expandedHeight: 0,
            leading: Padding(
              padding: EdgeInsetsDirectional.only(start: 8.w),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home/search');
                    }
                  },
                  child: Builder(
                    builder: (context) {
                      final isRtl = Localizations.localeOf(context).languageCode == 'he';
                      return Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          isRtl
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.arrow_back_ios_new_rounded,
                          size: 16.sp,
                          color: AppColors.textPrimary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _showTitleInAppBar ? 1.0 : 0.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 8.r,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: profile.avatarUrl != null
                          ? CachedNetworkImage(
                              imageUrl: profile.avatarUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => _AvatarPlaceholder(
                                initials: _getInitials(),
                                size: 32.r,
                              ),
                              errorWidget: (context, url, error) =>
                                  _AvatarPlaceholder(
                                    initials: _getInitials(),
                                    size: 32.r,
                                  ),
                            )
                          : _AvatarPlaceholder(
                              initials: _getInitials(),
                              size: 32.r,
                            ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Flexible(
                    child: Text(
                      profile.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Column(
                children: [
                  // Header avec avatar
                  _HeaderSection(profile: profile, initials: _getInitials()),
                  SizedBox(height: AppSpacing.lg.h),

                  // TabBar (Disponibilité | Avis) - contenu intégré au scroll unique
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: AppColors.outline.withValues(alpha: 0.12),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            _TabButton(
                              label: context.l10n.practitionerTabAvailability,
                              isSelected: _selectedTabIndex == 0,
                              onTap: () => setState(() => _selectedTabIndex = 0),
                            ),
                            _TabButton(
                              label: context.l10n.practitionerTabReviews,
                              isSelected: _selectedTabIndex == 1,
                              onTap: () => setState(() => _selectedTabIndex = 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      // Contenu selon l'onglet - tout dans le même scroll
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _selectedTabIndex == 0
                            ? Column(
                                key: const ValueKey('availability'),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _AvailabilityCalendar(
                                    practitionerId: widget.practitionerId,
                                    getSlots: sl<GetPractitionerSlots>(),
                                    onDateSelected: _onDateSelected,
                                    selectedDate: _selectedDate,
                                    compact: true,
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: _selectedDate != null
                                        ? Column(
                                            key: _timeSlotSectionKey,
                                            children: [
                                              SizedBox(height: AppSpacing.sm.h),
                                              _TimeSlotSection(
                                                practitionerId: widget.practitionerId,
                                                getSlots: sl<GetPractitionerSlots>(),
                                                selectedDate: _selectedDate!,
                                                selectedTime: _selectedTime,
                                                onSlotSelected: _onSlotSelected,
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: canBook
                                        ? Column(
                                            children: [
                                              SizedBox(height: AppSpacing.md.h),
                                              _BookingConfirmation(
                                                selectedDate: _selectedDate!,
                                                selectedTime: _selectedTime!,
                                                selectedEndTime: _selectedEndTime ?? _addMinutesToTime(_selectedTime!, 30),
                                                practitionerId: widget.practitionerId,
                                                practitionerName: profile.name,
                                                profile: profile,
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  SizedBox(height: AppSpacing.md.h),
                                  _AppointmentHistorySection(
                                    practitionerId: widget.practitionerId,
                                  ),
                                ],
                              )
                            : _ReviewsTabSection(
                                key: const ValueKey('reviews'),
                                practitionerId: widget.practitionerId,
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md.h),

                  // Section Contact
                  _ContactSection(
                    address: profile.address,
                    phone: profile.phone,
                    email: profile.email,
                    sector: profile.sector,
                  ),
                  SizedBox(height: AppSpacing.sm.h),

                  // Section Profil (masquée si vide)
                  if (profile.about.isNotEmpty || profile.education != null)
                    _AboutSection(
                      about: profile.about,
                      education: profile.education,
                      yearsOfExperience: profile.yearsOfExperience,
                    ),
                  SizedBox(height: AppSpacing.xl.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          margin: EdgeInsets.all(2.r),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 12.r,
                      offset: Offset(0, 2.h),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6.r,
                      offset: Offset(0, 1.h),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.profile, required this.initials});

  final PractitionerProfile profile;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 24.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28.r),
            child: profile.avatarUrl != null
                ? CachedNetworkImage(
                    imageUrl: profile.avatarUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        _AvatarPlaceholder(initials: initials, size: 100.r),
                    errorWidget: (context, url, error) =>
                        _AvatarPlaceholder(initials: initials, size: 100.r),
                  )
                : _AvatarPlaceholder(initials: initials, size: 100.r),
          ),
        ),
        SizedBox(height: AppSpacing.md.h),

        // Nom
        Text(
          profile.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        if (profile.rating != null || profile.reviewCount > 0) ...[
          SizedBox(height: 8.h),
          _RatingStars(
            rating: profile.rating ?? 0,
            reviewCount: profile.reviewCount,
          ),
        ],
        SizedBox(height: 8.h),

        // Spécialité badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadii.pill.r),
          ),
          child: Text(
            profile.specialty,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Langues (drapeau + nom) sous la spécialité
        if (profile.languages != null && profile.languages!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md.h),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10.w,
            runSpacing: 10.h,
            children: profile.languages!
                .map(
                  (lang) => _LanguageChip(
                    languageRaw: lang,
                    l10n: context.l10n,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

/// Affiche la note du praticien avec étoiles jaunes (1-5).
class _RatingStars extends StatelessWidget {
  const _RatingStars({
    required this.rating,
    required this.reviewCount,
  });

  final double rating;
  final int reviewCount;

  static const Color _starColor = Color(0xFFFFB800);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          final starValue = i + 1.0;
          IconData icon;
          if (rating >= starValue) {
            icon = Icons.star_rounded;
          } else if (rating >= starValue - 0.5) {
            icon = Icons.star_half_rounded;
          } else {
            icon = Icons.star_border_rounded;
          }
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Icon(icon, size: 18.sp, color: _starColor),
          );
        }),
        SizedBox(width: 8.w),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (reviewCount > 0) ...[
          SizedBox(width: 4.w),
          Text(
            '($reviewCount)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _AppointmentHistorySection extends StatelessWidget {
  const _AppointmentHistorySection({required this.practitionerId});

  final String practitionerId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (!authState.isAuthenticated) {
          return DokalCard(
            padding: EdgeInsets.all(AppSpacing.md.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 18.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      context.l10n.practitionerMyAppointmentsWithDoctor,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  context.l10n.practitionerLoginToSeeHistory,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return _AppointmentHistoryContent(practitionerId: practitionerId);
      },
    );
  }
}

class _AppointmentHistoryContent extends StatefulWidget {
  const _AppointmentHistoryContent({required this.practitionerId});

  final String practitionerId;

  @override
  State<_AppointmentHistoryContent> createState() =>
      _AppointmentHistoryContentState();
}

class _AppointmentHistoryContentState extends State<_AppointmentHistoryContent> {
  late final Future<List<dynamic>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    final getPast = sl<GetPastAppointments>();
    final getUpcoming = sl<GetUpcomingAppointments>();
    _appointmentsFuture = Future.wait([getPast(), getUpcoming()]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _appointmentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return DokalCard(
            padding: EdgeInsets.all(AppSpacing.md.r),
            child: const DokalLoader(lines: 3),
          );
        }
        final results = snapshot.data;
        if (results == null) {
          return const SizedBox.shrink();
        }
        final pastResult = results[0];
        final upcomingResult = results[1];

        List<Appointment> appointments = [];
        pastResult.fold((_) => null, (list) => appointments.addAll(list));
        upcomingResult.fold((_) => null, (list) => appointments.addAll(list));
        appointments = appointments
            .where((a) => a.practitionerId == widget.practitionerId)
            .toList()
          ..sort((a, b) {
            final da = '${a.dateLabel} ${a.timeLabel}';
            final db = '${b.dateLabel} ${b.timeLabel}';
            return db.compareTo(da);
          });

        if (appointments.isEmpty) {
          return DokalCard(
            padding: EdgeInsets.all(AppSpacing.md.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 18.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      context.l10n.practitionerMyAppointmentsWithDoctor,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  context.l10n.practitionerNoAppointmentsWithDoctor,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return DokalCard(
          padding: EdgeInsets.all(AppSpacing.md.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 18.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    context.l10n.practitionerMyAppointmentsWithDoctor,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm.h),
              ...appointments.map(
                (a) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
                  child: _AppointmentHistoryItem(appointment: a),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _AppointmentHistoryItem extends StatelessWidget {
  const _AppointmentHistoryItem({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm.r),
      decoration: BoxDecoration(
        color: appointment.isPast
            ? AppColors.textSecondary.withValues(alpha: 0.05)
            : AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14.sp,
                color: appointment.isPast
                    ? AppColors.textSecondary
                    : AppColors.accent,
              ),
             
              Expanded(
                child: Text(
                  '${formatAppointmentDateLabel(context, appointment.dateLabel)} • ${appointment.timeLabel}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(appointment.status)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    _statusLabel(context, appointment.status),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _statusColor(appointment.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (appointment.reason.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              appointment.reason,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (appointment.practitionerNotes != null &&
              appointment.practitionerNotes!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.note_rounded,
                  size: 12.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    appointment.practitionerNotes!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == 'completed') return AppColors.accent;
    if (status == 'confirmed' || status == 'pending') return AppColors.primary;
    if (status.contains('cancelled') || status == 'no_show') {
      return AppColors.textSecondary;
    }
    return AppColors.textPrimary;
  }

  String _statusLabel(BuildContext context, String status) {
    final l10n = context.l10n;
    if (status == 'completed') return l10n.practitionerAppointmentStatusCompleted;
    if (status == 'confirmed') return l10n.practitionerAppointmentStatusConfirmed;
    if (status == 'pending') return l10n.practitionerAppointmentStatusPending;
    if (status == 'cancelled_by_patient' ||
        status == 'cancelled_by_practitioner') {
      return l10n.practitionerAppointmentStatusCancelled;
    }
    if (status == 'no_show') return l10n.practitionerAppointmentStatusNoShow;
    return status;
  }
}

class _ReviewsTabSection extends StatelessWidget {
  const _ReviewsTabSection({
    super.key,
    required this.practitionerId,
  });

  final String practitionerId;

  @override
  Widget build(BuildContext context) {
    final getReviews = sl<GetPractitionerReviews>();

    return FutureBuilder(
      future: getReviews(practitionerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: DokalLoader(lines: 5));
        }
        final result = snapshot.data;
        if (result == null) {
          return Center(
            child: Text(
              context.l10n.commonTryAgainLater,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }
        return result.fold(
          (failure) => Center(
            child: Text(
              failure.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          (reviews) {
            if (reviews.isEmpty) {
              return Center(
                child: Text(
                  context.l10n.practitionerNoReviews,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: AppSpacing.sm.h),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final r = reviews[index];
                return _ReviewCard(
                  patientName: r['patient_name'] as String? ??
                      context.l10n.practitionerReviewAnonymous,
                  rating: r['rating'] as int? ?? 0,
                  comment: r['comment'] as String?,
                  practitionerReply: r['practitioner_reply'] as String?,
                  createdAt: r['created_at'] as String? ?? '',
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.patientName,
    required this.rating,
    this.comment,
    this.practitionerReply,
    required this.createdAt,
  });

  final String patientName;
  final int rating;
  final String? comment;
  final String? practitionerReply;
  final String createdAt;

  static const Color _starColor = Color(0xFFFFB800);

  String _formatDate(BuildContext context, String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      final locale = Localizations.localeOf(context);
      final localeStr =
          locale.countryCode != null && locale.countryCode!.isNotEmpty
              ? '${locale.languageCode}_${locale.countryCode}'
              : locale.languageCode;
      return DateFormat('d/M/y', localeStr).format(dt);
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = patientName.isNotEmpty
        ? patientName.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join('').toUpperCase()
        : '?';

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
      child: DokalCard(
        padding: EdgeInsets.all(AppSpacing.md.r),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < rating ? Icons.star_rounded : Icons.star_border_rounded,
                          size: 14.sp,
                          color: _starColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatDate(context, createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (comment != null && comment!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm.h),
            Text(
              comment!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (practitionerReply != null && practitionerReply!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm.h),
            Container(
              padding: EdgeInsets.all(AppSpacing.sm.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.reply_rounded, size: 16.sp, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      practitionerReply!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }
}

class _AvailabilityCalendar extends StatefulWidget {
  const _AvailabilityCalendar({
    required this.practitionerId,
    required this.getSlots,
    required this.onDateSelected,
    this.selectedDate,
    this.compact = false,
  });

  final String practitionerId;
  final GetPractitionerSlots getSlots;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? selectedDate;
  final bool compact;

  @override
  State<_AvailabilityCalendar> createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<_AvailabilityCalendar> {
  late DateTime _currentMonth;
  final DateTime _today = DateTime.now();

  Set<DateTime> _availableDates = {};
  bool _isLoadingSlots = true;
  String? _slotsError;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(_today.year, _today.month);
    _loadSlotsForMonth();
  }

  Future<void> _loadSlotsForMonth() async {
    if (!mounted) return;
    setState(() {
      _isLoadingSlots = true;
      _slotsError = null;
    });

    final from = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final to = DateTime(lastDay.year, lastDay.month, lastDay.day);

    final fromStr = DateFormat('yyyy-MM-dd').format(from);
    final toStr = DateFormat('yyyy-MM-dd').format(to);

    final result = await widget.getSlots(
      widget.practitionerId,
      from: fromStr,
      to: toStr,
    );

    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _availableDates = {};
        _isLoadingSlots = false;
        _slotsError = failure.message;
      }),
      (slots) {
        final dates = <DateTime>{};
        for (final slot in slots) {
          final dateStr = slot['slot_date'];
          if (dateStr != null && dateStr.isNotEmpty) {
            final parsed = DateTime.tryParse(dateStr);
            if (parsed != null) {
              dates.add(DateTime(parsed.year, parsed.month, parsed.day));
            }
          }
        }
        setState(() {
          _availableDates = dates;
          _isLoadingSlots = false;
          _slotsError = null;
        });
      },
    );
  }

  bool _isAvailable(DateTime date) {
    return _availableDates.contains(DateTime(date.year, date.month, date.day));
  }

  bool _isToday(DateTime date) {
    return date.year == _today.year &&
        date.month == _today.month &&
        date.day == _today.day;
  }

  bool _isSelected(DateTime date) {
    if (widget.selectedDate == null) return false;
    return date.year == widget.selectedDate!.year &&
        date.month == widget.selectedDate!.month &&
        date.day == widget.selectedDate!.day;
  }

  void _previousMonth() {
    if (_currentMonth.isAfter(DateTime(_today.year, _today.month))) {
      setState(() {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      });
      _loadSlotsForMonth();
    }
  }

  void _nextMonth() {
    final maxMonth = DateTime(_today.year, _today.month + 2);
    if (_currentMonth.isBefore(maxMonth)) {
      setState(() {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      });
      _loadSlotsForMonth();
    }
  }

  String _getMonthName(BuildContext context, int month, int year) {
    final locale = Localizations.localeOf(context);
    final localeStr =
        locale.countryCode != null && locale.countryCode!.isNotEmpty
            ? '${locale.languageCode}_${locale.countryCode}'
            : locale.languageCode;
    return DateFormat('MMMM yyyy', localeStr)
        .format(DateTime(year, month));
  }

  List<String> _getWeekdayAbbreviations(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeStr =
        locale.countryCode != null && locale.countryCode!.isNotEmpty
            ? '${locale.languageCode}_${locale.countryCode}'
            : locale.languageCode;
    final format = DateFormat('E', localeStr);
    return List.generate(7, (i) {
      final date = DateTime.utc(2024, 1, 7 + i);
      return format.format(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;
    final firstDayOfWeek = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    ).weekday;
    // Adjust for Sunday start (Hebrew calendar)
    final startOffset = firstDayOfWeek == 7 ? 0 : firstDayOfWeek;

    final canGoBack = _currentMonth.isAfter(
      DateTime(_today.year, _today.month),
    );
    final canGoNext = _currentMonth.isBefore(
      DateTime(_today.year, _today.month + 2),
    );

    return DokalCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (masqué en mode compact - onglet déjà explicite)
          if (!widget.compact) ...[
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    size: 18.sp,
                    color: AppColors.accent,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    l10n.practitionerAvailabilities,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
          ],

          // Month navigation: LTR = left=previous, right=next | RTL (Hebrew) = left=next, right=previous
          Builder(
            builder: (context) {
              final isRtl = Localizations.localeOf(context).languageCode == 'he';
              final prevBtn = GestureDetector(
                onTap: canGoBack ? _previousMonth : null,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: canGoBack
                        ? AppColors.surfaceVariant
                        : AppColors.surfaceVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    size: 20.sp,
                    color: canGoBack
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              );
              final nextBtn = GestureDetector(
                onTap: canGoNext ? _nextMonth : null,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: canGoNext
                        ? AppColors.surfaceVariant
                        : AppColors.surfaceVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 20.sp,
                    color: canGoNext
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              );
              final monthText = Text(
                _getMonthName(
                  context,
                  _currentMonth.month,
                  _currentMonth.year,
                ),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              );
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: isRtl
                    ? [nextBtn, monthText, prevBtn]
                    : [prevBtn, monthText, nextBtn],
              );
            },
          ),
          SizedBox(height: AppSpacing.md.h),

          // Day headers (locale-aware)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _getWeekdayAbbreviations(context)
                .map(
                  (day) => SizedBox(
                    width: 36.r,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 8.h),

          if (_isLoadingSlots)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.r,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          else if (_slotsError != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                _slotsError!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else ...[
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4.h,
              crossAxisSpacing: 4.w,
              childAspectRatio: 1,
            ),
            itemCount: startOffset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startOffset) {
                return const SizedBox();
              }
              final day = index - startOffset + 1;
              final date = DateTime(
                _currentMonth.year,
                _currentMonth.month,
                day,
              );
              final isAvailable = _isAvailable(date);
              final isToday = _isToday(date);
              final isSelected = _isSelected(date);
              final isPast = date.isBefore(
                DateTime(_today.year, _today.month, _today.day),
              );

              return GestureDetector(
                onTap: isAvailable && !isPast
                    ? () => widget.onDateSelected(date)
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected && isAvailable
                        ? AppColors.primary
                        : isAvailable && !isPast
                        ? AppColors.accent.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                    border: isToday
                        ? Border.all(color: AppColors.primary, width: 1.5.w)
                        : null,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected && isAvailable
                                ? Colors.white
                                : isPast
                                ? AppColors.textSecondary.withValues(alpha: 0.4)
                                : isAvailable
                                ? AppColors.textPrimary
                                : AppColors.textSecondary.withValues(
                                    alpha: 0.6,
                                  ),
                          ),
                        ),
                        if (isAvailable && !isPast && !isSelected)
                          Container(
                            margin: EdgeInsets.only(top: 2.h),
                            width: 4.r,
                            height: 4.r,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          if (!widget.compact) ...[
            SizedBox(height: AppSpacing.md.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(
                  color: AppColors.accent,
                  label: context.l10n.practitionerCalendarLegendAvailable,
                ),
                SizedBox(width: 20.w),
                _LegendItem(
                  color: AppColors.primary,
                  label: context.l10n.practitionerCalendarLegendSelected,
                  isFilled: true,
                ),
              ],
            ),
          ],
          ],
        ],
      ),
    );
  }
}

class _TimeSlotSection extends StatefulWidget {
  const _TimeSlotSection({
    required this.practitionerId,
    required this.getSlots,
    required this.selectedDate,
    required this.selectedTime,
    required this.onSlotSelected,
  });

  final String practitionerId;
  final GetPractitionerSlots getSlots;
  final DateTime selectedDate;
  final String? selectedTime;
  final ValueChanged<({String start, String end})> onSlotSelected;

  @override
  State<_TimeSlotSection> createState() => _TimeSlotSectionState();
}

class _TimeSlotSectionState extends State<_TimeSlotSection> {
  List<({String start, String end})> _slots = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSlotsForDate();
  }

  @override
  void didUpdateWidget(covariant _TimeSlotSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadSlotsForDate();
    }
  }

  Future<void> _loadSlotsForDate() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final dateStr = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    final result = await widget.getSlots(
      widget.practitionerId,
      from: dateStr,
      to: dateStr,
    );

    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _slots = [];
        _isLoading = false;
        _error = failure.message;
      }),
      (slots) {
        final list = <({String start, String end})>[];
        for (final slot in slots) {
          final start = slot['slot_start'];
          final end = slot['slot_end'];
          if (start != null && start.isNotEmpty) {
            final startDisplay = formatTimeTo24h(start);
            final endDisplay =
                end != null && end.isNotEmpty
                    ? formatTimeTo24h(end)
                    : _addMinutesToTime(formatTimeTo24h(start), 30);
            list.add((
              start: startDisplay,
              end: endDisplay,
            ));
          }
        }
        list.sort((a, b) => a.start.compareTo(b.start));
        setState(() {
          _slots = list;
          _isLoading = false;
          _error = null;
        });
      },
    );
  }

  String _formatDate(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return DateFormat('EEEE, d/M', locale.toLanguageTag())
        .format(widget.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DokalCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 20.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 10.w),
              Text(
                _formatDate(context),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),

          if (_isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.r,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          else if (_error != null)
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else if (_slots.isEmpty)
            Text(
              l10n.practitionerNoSlotsForDate,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else
            // Time slots grid
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: _slots.map((slot) {
                final isSelected = widget.selectedTime == slot.start;
                return GestureDetector(
                  onTap: () => widget.onSlotSelected((start: slot.start, end: slot.end)),
                  child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.2),
                      width: isSelected ? 2.r : 1.r,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 8.r,
                              offset: Offset(0, 4.h),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    slot.start,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _BookingConfirmation extends StatelessWidget {
  const _BookingConfirmation({
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedEndTime,
    required this.practitionerId,
    required this.practitionerName,
    required this.profile,
  });

  final DateTime selectedDate;
  final String selectedTime;
  final String selectedEndTime;
  final String practitionerId;
  final String practitionerName;
  final PractitionerProfile profile;

  String _formatFullDate(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeStr =
        locale.countryCode != null && locale.countryCode!.isNotEmpty
            ? '${locale.languageCode}_${locale.countryCode}'
            : locale.languageCode;
    return DateFormat('EEEE, d MMMM', localeStr).format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // Summary
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 24.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'התור שלך',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${formatTimeTo24h(selectedTime)} • ${_formatFullDate(context)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),

          // Book button - ouvre le flux de réservation rapide
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => QuickBookingSheet.show(
                context,
                practitionerId: practitionerId,
                practitionerName: practitionerName,
                profile: profile,
                appointmentDate: selectedDate,
                startTime: selectedTime,
                endTime: selectedEndTime,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_available_rounded, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    l10n.practitionerBookAppointment,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
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

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.isFilled = false,
  });

  final Color color;
  final String label;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.r,
          height: 12.r,
          decoration: BoxDecoration(
            color: isFilled ? color : color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4.r),
            border: !isFilled ? Border.all(color: color, width: 1.w) : null,
          ),
          child: isFilled
              ? null
              : Center(
                  child: Container(
                    width: 4.r,
                    height: 4.r,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({
    required this.address,
    this.phone,
    this.email,
    this.sector,
  });

  final String address;
  final String? phone;
  final String? email;
  final String? sector;

  @override
  Widget build(BuildContext context) {
    return DokalCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 18.sp,
                  color: AppColors.accent,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                context.l10n.practitionerAddressAndContact,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),

          // Address
          _ContactItem(
            icon: Icons.place_rounded,
            iconColor: AppColors.accent,
            text: address,
          ),

          // Sector (Kupat Holim)
          if (sector != null) ...[
            SizedBox(height: 10.h),
            _ContactItem(
              icon: Icons.health_and_safety_rounded,
              iconColor: AppColors.accent,
              text: sector!,
            ),
          ],

          // Phone
          if (phone != null) ...[
            SizedBox(height: 10.h),
            _ContactItem(
              icon: Icons.phone_rounded,
              iconColor: AppColors.primary,
              text: phone!,
            ),
          ],

          // Email
          if (email != null) ...[
            SizedBox(height: 10.h),
            _ContactItem(
              icon: Icons.email_rounded,
              iconColor: AppColors.primary,
              text: email!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: iconColor),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({
    required this.about,
    this.education,
    this.yearsOfExperience,
  });

  final String about;
  final String? education;
  final int? yearsOfExperience;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DokalCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                l10n.practitionerProfileSection,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),

          // About text
          Text(
            about,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          // Education
          if (education != null) ...[
            SizedBox(height: AppSpacing.md.h),
            _InfoChip(
              icon: Icons.school_rounded,
              label: education!,
              color: const Color(0xFF8B5CF6),
            ),
          ],
        ],
      ),
    );
  }
}

/// Affiche une langue avec drapeau et nom localisé.
class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.languageRaw,
    required this.l10n,
  });

  final String languageRaw;
  final dynamic l10n;

  static const Map<String, String> _countryCodeMap = {
    'he': 'IL', 'iw': 'IL', 'heb': 'IL', 'hebrew': 'IL', 'עברית': 'IL',
    'fr': 'FR', 'fra': 'FR', 'french': 'FR', 'français': 'FR',
    'en': 'US', 'eng': 'US', 'english': 'US',
    'ru': 'RU', 'rus': 'RU', 'russian': 'RU',
    'es': 'ES', 'spa': 'ES', 'spanish': 'ES',
    'am': 'ET', 'amh': 'ET', 'amharic': 'ET',
    'ar': 'SA', 'ara': 'SA', 'arabic': 'SA',
  };

  String _getDisplayName(String normalized) {
    switch (normalized) {
      case 'he': case 'iw': case 'heb': case 'hebrew': case 'עברית':
        return l10n.practitionerLanguageHebrew;
      case 'fr': case 'fra': case 'french': case 'français':
        return l10n.practitionerLanguageFrench;
      case 'en': case 'eng': case 'english':
        return l10n.practitionerLanguageEnglish;
      case 'ru': case 'rus': case 'russian':
        return l10n.practitionerLanguageRussian;
      case 'es': case 'spa': case 'spanish':
        return l10n.practitionerLanguageSpanish;
      case 'am': case 'amh': case 'amharic':
        return l10n.practitionerLanguageAmharic;
      case 'ar': case 'ara': case 'arabic':
        return l10n.practitionerLanguageArabic;
      default:
        return languageRaw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final normalized = languageRaw.trim().toLowerCase();
    final countryCode = _countryCodeMap[normalized] ?? 'UN';
    final displayName = _countryCodeMap.containsKey(normalized)
        ? _getDisplayName(normalized)
        : languageRaw;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: CountryFlag.fromCountryCode(
              countryCode,
              theme: ImageTheme(
                width: 20.w,
                height: 14.h,
                shape: RoundedRectangle(4.r),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            displayName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 6.w),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.initials, required this.size});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.35,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
