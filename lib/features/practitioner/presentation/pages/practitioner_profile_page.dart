import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/practitioner_profile.dart';
import '../bloc/practitioner_cubit.dart';

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
  bool _showTitleInAppBar = false;
  DateTime? _selectedDate;
  String? _selectedTime;

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
      _selectedTime = null; // Reset time when date changes
    });
  }

  void _onTimeSelected(String time) {
    setState(() {
      _selectedTime = time;
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
              padding: EdgeInsets.only(left: 8.w),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      // Si on arrive ici via un redirect / remplacement de stack,
                      // il n'y a parfois rien à "pop". On renvoie vers la recherche.
                      context.go('/home/search');
                    }
                  },
                  child: Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
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

                  // Calendrier de disponibilités
                  _AvailabilityCalendar(
                    onDateSelected: _onDateSelected,
                    selectedDate: _selectedDate,
                  ),

                  // Section horaires (apparaît après sélection de date)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _selectedDate != null
                        ? Column(
                            children: [
                              SizedBox(height: AppSpacing.sm.h),
                              _TimeSlotSection(
                                selectedDate: _selectedDate!,
                                selectedTime: _selectedTime,
                                onTimeSelected: _onTimeSelected,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Bouton de réservation (apparaît après sélection de date ET heure)
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
                                practitionerId: widget.practitionerId,
                                practitionerName: profile.name,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
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

                  // Section Profil
                  _AboutSection(
                    about: profile.about,
                    languages: profile.languages,
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
        SizedBox(height: AppSpacing.md.h),

        // Stats row
        if (profile.yearsOfExperience != null || profile.languages != null)
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (profile.yearsOfExperience != null)
                  _StatItem(
                    icon: Icons.workspace_premium_rounded,
                    value: '${profile.yearsOfExperience}',
                    label: 'שנות ניסיון',
                    color: AppColors.accent,
                  ),
                if (profile.yearsOfExperience != null &&
                    profile.languages != null)
                  Container(width: 1, height: 36.h, color: AppColors.outline),
                if (profile.languages != null)
                  _StatItem(
                    icon: Icons.translate_rounded,
                    value: '${profile.languages!.length}',
                    label: 'שפות',
                    color: AppColors.primary,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18.sp, color: color),
            SizedBox(width: 6.w),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
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

class _AvailabilityCalendar extends StatefulWidget {
  const _AvailabilityCalendar({
    required this.onDateSelected,
    this.selectedDate,
  });

  final ValueChanged<DateTime> onDateSelected;
  final DateTime? selectedDate;

  @override
  State<_AvailabilityCalendar> createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<_AvailabilityCalendar> {
  late DateTime _currentMonth;
  final DateTime _today = DateTime.now();

  // Simulated available dates (in real app, this would come from backend)
  late Set<DateTime> _availableDates;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(_today.year, _today.month);
    _generateAvailableDates();
  }

  void _generateAvailableDates() {
    // Generate some mock available dates for the next 3 months
    _availableDates = {};
    final random = [2, 3, 5, 7, 9, 11, 14, 16, 18, 21, 23, 25, 28, 29, 30];
    for (int m = 0; m < 3; m++) {
      final month = DateTime(_today.year, _today.month + m);
      for (final day in random) {
        final date = DateTime(month.year, month.month, day);
        if (date.isAfter(_today.subtract(const Duration(days: 1)))) {
          _availableDates.add(DateTime(date.year, date.month, date.day));
        }
      }
    }
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
    }
  }

  void _nextMonth() {
    final maxMonth = DateTime(_today.year, _today.month + 2);
    if (_currentMonth.isBefore(maxMonth)) {
      setState(() {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      });
    }
  }

  String _getHebrewMonth(int month) {
    const months = [
      'ינואר',
      'פברואר',
      'מרץ',
      'אפריל',
      'מאי',
      'יוני',
      'יולי',
      'אוגוסט',
      'ספטמבר',
      'אוקטובר',
      'נובמבר',
      'דצמבר',
    ];
    return months[month - 1];
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
        children: [
          // Header
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

          // Month navigation (RTL - Hebrew reads right to left)
          // Left side = future (next month), Right side = past (previous month)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left button: goes to NEXT month (future) - shows < arrow
              GestureDetector(
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
                    Icons.chevron_left_rounded,
                    size: 20.sp,
                    color: canGoNext
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Text(
                '${_getHebrewMonth(_currentMonth.month)} ${_currentMonth.year}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              // Right button: goes to PREVIOUS month (past) - shows > arrow
              GestureDetector(
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
                    Icons.chevron_right_rounded,
                    size: 20.sp,
                    color: canGoBack
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),

          // Day headers (RTL order)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'ש']
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
                        ? Border.all(color: AppColors.primary, width: 1.5)
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
          SizedBox(height: AppSpacing.md.h),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: AppColors.accent, label: 'זמין'),
              SizedBox(width: 20.w),
              _LegendItem(
                color: AppColors.primary,
                label: 'נבחר',
                isFilled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeSlotSection extends StatelessWidget {
  const _TimeSlotSection({
    required this.selectedDate,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  final DateTime selectedDate;
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;

  // Generate mock time slots based on date
  List<String> _getAvailableTimeSlots() {
    // Different times for different days to simulate real data
    final day = selectedDate.day;
    if (day % 3 == 0) {
      return ['09:00', '10:30', '14:00', '15:30', '17:00'];
    } else if (day % 2 == 0) {
      return ['08:30', '11:00', '13:30', '16:00'];
    } else {
      return ['09:30', '11:30', '14:30', '16:30', '18:00'];
    }
  }

  String _getHebrewDayName(int weekday) {
    const days = ['ב\'', 'ג\'', 'ד\'', 'ה\'', 'ו\'', 'ש\'', 'א\''];
    return days[weekday - 1];
  }

  String _formatDate() {
    final day = selectedDate.day;
    final month = selectedDate.month;
    final dayName = _getHebrewDayName(selectedDate.weekday);
    return 'יום $dayName, $day/$month';
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = _getAvailableTimeSlots();

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
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  size: 18.sp,
                  color: const Color(0xFF3B82F6),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'בחר שעה',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _formatDate(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),

          // Time slots grid
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: timeSlots.map((time) {
              final isSelected = selectedTime == time;
              return GestureDetector(
                onTap: () => onTimeSelected(time),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFF3B82F6).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFF3B82F6).withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8.r,
                              offset: Offset(0, 4.h),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    time,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF3B82F6),
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
    required this.practitionerId,
    required this.practitionerName,
  });

  final DateTime selectedDate;
  final String selectedTime;
  final String practitionerId;
  final String practitionerName;

  String _formatFullDate() {
    const days = [
      'יום שני',
      'יום שלישי',
      'יום רביעי',
      'יום חמישי',
      'יום שישי',
      'יום שבת',
      'יום ראשון',
    ];
    const months = [
      'בינואר',
      'בפברואר',
      'במרץ',
      'באפריל',
      'במאי',
      'ביוני',
      'ביולי',
      'באוגוסט',
      'בספטמבר',
      'באוקטובר',
      'בנובמבר',
      'בדצמבר',
    ];
    final dayName = days[selectedDate.weekday - 1];
    final month = months[selectedDate.month - 1];
    return '$dayName, ${selectedDate.day} $month';
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
                      '$selectedTime • ${_formatFullDate()}',
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

          // Book button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // `push` garde un historique correct quand on revient en arrière
              // (ex: login gate sur les routes protégées).
              onPressed: () => context.push('/booking/$practitionerId'),
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
            border: !isFilled ? Border.all(color: color, width: 1) : null,
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
                  color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 18.sp,
                  color: const Color(0xFFEF4444),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'כתובת ויצירת קשר',
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
            iconColor: const Color(0xFFEF4444),
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
              iconColor: const Color(0xFF3B82F6),
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
    this.languages,
    this.education,
    this.yearsOfExperience,
  });

  final String about;
  final List<String>? languages;
  final String? education;
  final int? yearsOfExperience;

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
                'פרופיל',
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

          // Languages
          if (languages != null && languages!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: languages!
                  .map(
                    (lang) => _InfoChip(
                      icon: Icons.translate_rounded,
                      label: lang,
                      color: AppColors.primary,
                    ),
                  )
                  .toList(),
            ),
          ],
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
