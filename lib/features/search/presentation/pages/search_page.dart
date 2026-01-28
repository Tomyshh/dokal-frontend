import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../core/widgets/practitioner_card.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/practitioner_search_result.dart';
import '../bloc/search_cubit.dart';

/// Options de tri disponibles
enum SortOption {
  availability,
  distance,
  name,
  rating,
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SortOption _currentSort = SortOption.availability;

  List<PractitionerSearchResult> _sortResults(
    List<PractitionerSearchResult> results,
  ) {
    final sorted = List<PractitionerSearchResult>.from(results);
    switch (_currentSort) {
      case SortOption.availability:
        sorted.sort((a, b) {
          final aOrder = a.availabilityOrder ?? 999;
          final bOrder = b.availabilityOrder ?? 999;
          return aOrder.compareTo(bOrder);
        });
      case SortOption.distance:
        sorted.sort((a, b) {
          final aDistance = a.distanceKm ?? double.infinity;
          final bDistance = b.distanceKm ?? double.infinity;
          return aDistance.compareTo(bDistance);
        });
      case SortOption.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case SortOption.rating:
        // Pour le moment, tri par disponibilité comme fallback
        sorted.sort((a, b) {
          final aOrder = a.availabilityOrder ?? 999;
          final bOrder = b.availabilityOrder ?? 999;
          return aOrder.compareTo(bOrder);
        });
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: Scaffold(
        appBar: DokalAppBar(title: l10n.searchTitle),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Column(
              children: [
                SizedBox(height: AppSpacing.sm.h),
                _SearchBar(
                  currentSort: _currentSort,
                  onSortChanged: (sort) => setState(() => _currentSort = sort),
                ),
                SizedBox(height: AppSpacing.md.h),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state.status == SearchStatus.loading) {
                        return Padding(
                          padding: EdgeInsets.only(top: AppSpacing.sm.h),
                          child: const DokalLoader(lines: 6),
                        );
                      }
                      if (state.status == SearchStatus.failure) {
                        return DokalEmptyState(
                          title: l10n.searchUnavailableTitle,
                          subtitle: state.error ?? l10n.commonTryAgainLater,
                          icon: Icons.search_off_rounded,
                        );
                      }
                      final List<PractitionerSearchResult> results =
                          _sortResults(state.results);
                      if (results.isEmpty) {
                        return DokalEmptyState(
                          title: l10n.searchNoResultsTitle,
                          subtitle: l10n.searchNoResultsSubtitle,
                          icon: Icons.search_rounded,
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.only(bottom: AppSpacing.lg.h),
                        itemCount: results.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: AppSpacing.sm.h),
                        itemBuilder: (context, index) {
                          final p = results[index];
                          return PractitionerCard(
                            name: p.name,
                            specialty: p.specialty,
                            address: p.address,
                            sector: p.sector,
                            nextAvailabilityLabel: p.nextAvailabilityLabel,
                            distanceLabel: p.distanceLabel,
                            avatarUrl: p.avatarUrl,
                            onTap: () => context.push('/practitioner/${p.id}'),
                          );
                        },
                      );
                    },
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

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.currentSort,
    required this.onSortChanged,
  });

  final SortOption currentSort;
  final ValueChanged<SortOption> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        // Barre de recherche
        Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                child: BlocBuilder<SearchCubit, SearchState>(
                  buildWhen: (p, n) => p.query != n.query,
                  builder: (context, state) {
                    return TextField(
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.searchHint,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          letterSpacing: 0.1,
                        ),
                      ),
                      onChanged: context.read<SearchCubit>().setQuery,
                    );
                  },
                ),
              ),
              // Bouton de tri
              GestureDetector(
                onTap: () => _showSortMenu(context),
                child: Container(
                  height: 36.r,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: currentSort != SortOption.availability
                        ? AppColors.accent.withValues(alpha: 0.1)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10.r),
                    border: currentSort != SortOption.availability
                        ? Border.all(
                            color: AppColors.accent.withValues(alpha: 0.3),
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swap_vert_rounded,
                        color: currentSort != SortOption.availability
                            ? AppColors.accent
                            : AppColors.textSecondary,
                        size: 18.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _getSortLabel(context, currentSort),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: currentSort != SortOption.availability
                                  ? AppColors.accent
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // Bouton de filtre
              GestureDetector(
                onTap: () => _showFilterBottomSheet(context),
                child: Container(
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getSortLabel(BuildContext context, SortOption sort) {
    final l10n = context.l10n;
    switch (sort) {
      case SortOption.availability:
        return l10n.searchSortAvailability;
      case SortOption.distance:
        return l10n.searchSortDistance;
      case SortOption.name:
        return l10n.searchSortName;
      case SortOption.rating:
        return l10n.searchSortRating;
    }
  }

  void _showSortMenu(BuildContext context) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.swap_vert_rounded,
                          color: AppColors.primary,
                          size: 22.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          l10n.searchSortTitle,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _SortOptionTile(
                      icon: Icons.schedule_rounded,
                      label: l10n.searchSortAvailability,
                      subtitle: 'מהזמין ביותר לזמין פחות',
                      isSelected: currentSort == SortOption.availability,
                      color: AppColors.accent,
                      onTap: () {
                        onSortChanged(SortOption.availability);
                        Navigator.of(ctx).pop();
                      },
                    ),
                    SizedBox(height: 8.h),
                    _SortOptionTile(
                      icon: Icons.near_me_rounded,
                      label: l10n.searchSortDistance,
                      subtitle: 'מהקרוב ביותר לרחוק',
                      isSelected: currentSort == SortOption.distance,
                      color: AppColors.warning,
                      onTap: () {
                        onSortChanged(SortOption.distance);
                        Navigator.of(ctx).pop();
                      },
                    ),
                    SizedBox(height: 8.h),
                    _SortOptionTile(
                      icon: Icons.sort_by_alpha_rounded,
                      label: l10n.searchSortName,
                      subtitle: 'לפי סדר א-ב',
                      isSelected: currentSort == SortOption.name,
                      color: AppColors.primary,
                      onTap: () {
                        onSortChanged(SortOption.name);
                        Navigator.of(ctx).pop();
                      },
                    ),
                    SizedBox(height: 8.h),
                    _SortOptionTile(
                      icon: Icons.star_rounded,
                      label: l10n.searchSortRating,
                      subtitle: 'מהמדורג ביותר',
                      isSelected: currentSort == SortOption.rating,
                      color: const Color(0xFFF59E0B),
                      onTap: () {
                        onSortChanged(SortOption.rating);
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _FilterBottomSheet(),
    );
  }
}

class _SortOptionTile extends StatelessWidget {
  const _SortOptionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? color.withValues(alpha: 0.3) : AppColors.outline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? color : AppColors.textPrimary,
                        ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet();

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String? _selectedDate;
  String? _selectedSpecialty;
  String? _selectedKupat;
  double _maxDistance = 50;

  static const List<String> _specialties = [
    'רופא משפחה',
    'רופא עיניים',
    'קרדיולוג',
    'רופא עור',
    'רופא ילדים',
    'גינקולוגית',
    'אורטופד',
    'נוירולוג',
    'רופא פנימי',
    'פסיכיאטר',
  ];

  static const List<String> _kupatHolim = [
    'כללית',
    'מכבי',
    'מאוחדת',
    'לאומית',
  ];

  int get _activeFilterCount {
    int count = 0;
    if (_selectedDate != null) count++;
    if (_selectedSpecialty != null) count++;
    if (_selectedKupat != null) count++;
    if (_maxDistance < 50) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.searchFilterTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                ),
                if (_activeFilterCount > 0)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadii.pill.r),
                    ),
                    child: Text(
                      l10n.searchFilterActiveCount(_activeFilterCount),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(color: AppColors.outline, height: 1),
          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date filter
                  _FilterSection(
                    title: l10n.searchFilterDate,
                    icon: Icons.calendar_today_rounded,
                    iconColor: AppColors.primary,
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _FilterChip(
                          label: l10n.searchFilterDateAny,
                          isSelected: _selectedDate == null,
                          onTap: () => setState(() => _selectedDate = null),
                        ),
                        _FilterChip(
                          label: l10n.searchFilterDateToday,
                          isSelected: _selectedDate == 'today',
                          onTap: () =>
                              setState(() => _selectedDate = 'today'),
                          accentColor: AppColors.accent,
                        ),
                        _FilterChip(
                          label: l10n.searchFilterDateTomorrow,
                          isSelected: _selectedDate == 'tomorrow',
                          onTap: () =>
                              setState(() => _selectedDate = 'tomorrow'),
                        ),
                        _FilterChip(
                          label: l10n.searchFilterDateThisWeek,
                          isSelected: _selectedDate == 'this_week',
                          onTap: () =>
                              setState(() => _selectedDate = 'this_week'),
                        ),
                        _FilterChip(
                          label: l10n.searchFilterDateNextWeek,
                          isSelected: _selectedDate == 'next_week',
                          onTap: () =>
                              setState(() => _selectedDate = 'next_week'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  // Specialty filter
                  _FilterSection(
                    title: l10n.searchFilterSpecialty,
                    icon: Icons.medical_services_rounded,
                    iconColor: AppColors.primary,
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _FilterChip(
                          label: l10n.searchFilterSpecialtyAll,
                          isSelected: _selectedSpecialty == null,
                          onTap: () =>
                              setState(() => _selectedSpecialty = null),
                        ),
                        ..._specialties.map(
                          (s) => _FilterChip(
                            label: s,
                            isSelected: _selectedSpecialty == s,
                            onTap: () =>
                                setState(() => _selectedSpecialty = s),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  // Kupat Holim filter
                  _FilterSection(
                    title: l10n.searchFilterKupatHolim,
                    icon: Icons.health_and_safety_rounded,
                    iconColor: AppColors.accent,
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _FilterChip(
                          label: l10n.searchFilterKupatHolimAll,
                          isSelected: _selectedKupat == null,
                          onTap: () => setState(() => _selectedKupat = null),
                        ),
                        ..._kupatHolim.map(
                          (k) => _FilterChip(
                            label: k,
                            isSelected: _selectedKupat == k,
                            onTap: () => setState(() => _selectedKupat = k),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  // Distance filter
                  _FilterSection(
                    title: l10n.searchFilterDistance,
                    icon: Icons.location_on_rounded,
                    iconColor: AppColors.warning,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _maxDistance >= 50
                                  ? l10n.searchFilterDistanceAny
                                  : '${_maxDistance.round()} ק"מ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: _maxDistance < 50
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor:
                                AppColors.primary.withValues(alpha: 0.15),
                            thumbColor: AppColors.primary,
                            overlayColor:
                                AppColors.primary.withValues(alpha: 0.1),
                            trackHeight: 4.h,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 10.r,
                            ),
                          ),
                          child: Slider(
                            value: _maxDistance,
                            min: 1,
                            max: 50,
                            divisions: 49,
                            onChanged: (v) =>
                                setState(() => _maxDistance = v),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1 ק"מ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              Text(
                                '50+ ק"מ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Footer buttons
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10.r,
                  offset: Offset(0, -4.h),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = null;
                          _selectedSpecialty = null;
                          _selectedKupat = null;
                          _maxDistance = 50;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.outline),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        l10n.searchFilterReset,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: DokalButton.primary(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.searchFilterApply),
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

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                size: 16.sp,
                color: iconColor,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        child,
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.accentColor,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.md.r),
          border: Border.all(
            color: isSelected ? color : AppColors.outline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
