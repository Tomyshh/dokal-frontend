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
import '../widgets/search_practitioner_card.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/practitioner_search_result.dart';
import '../bloc/search_cubit.dart';

/// Options de tri disponibles
enum SortOption { availability, distance, name, rating, price }

/// Plage de prix pour le filtre (agorot = ILS × 100)
enum PriceRangeFilter {
  all,
  under200,
  range200_300,
  range300_500,
  over500,
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SortOption _currentSort = SortOption.availability;
  PriceRangeFilter _priceFilter = PriceRangeFilter.all;
  String? _languageFilter;

  List<PractitionerSearchResult> _applyFilters(
    List<PractitionerSearchResult> results,
  ) {
    var filtered = results;
    if (_priceFilter != PriceRangeFilter.all) {
      filtered = filtered.where((p) {
      final min = p.priceMinAgorot;
      final max = p.priceMaxAgorot ?? min;
      final effectiveMax = max ?? min ?? 0;
      final effectiveMin = min ?? max ?? 0;
      switch (_priceFilter) {
        case PriceRangeFilter.under200:
          return effectiveMax <= 20000;
        case PriceRangeFilter.range200_300:
          return effectiveMin <= 30000 && effectiveMax >= 20000;
        case PriceRangeFilter.range300_500:
          return effectiveMin <= 50000 && effectiveMax >= 30000;
        case PriceRangeFilter.over500:
          return effectiveMin >= 50000;
        default:
          return true;
      }
    }).toList();
    }
    if (_languageFilter != null && _languageFilter!.isNotEmpty) {
      final lang = _languageFilter!.trim().toLowerCase();
      filtered = filtered.where((p) {
        final langs = p.languages;
        if (langs == null || langs.isEmpty) return false;
        return langs.any((l) => l.trim().toLowerCase() == lang);
      }).toList();
    }
    return filtered;
  }

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
        sorted.sort((a, b) {
          final aRating = a.rating ?? 0.0;
          final bRating = b.rating ?? 0.0;
          return bRating.compareTo(aRating);
        });
      case SortOption.price:
        sorted.sort((a, b) {
          final aPrice = a.priceMaxAgorot ?? a.priceMinAgorot ?? 0;
          final bPrice = b.priceMaxAgorot ?? b.priceMinAgorot ?? 0;
          return bPrice.compareTo(aPrice);
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
                  priceFilter: _priceFilter,
                  onPriceFilterChanged: (f) =>
                      setState(() => _priceFilter = f),
                  languageFilter: _languageFilter,
                  onLanguageFilterChanged: (l) =>
                      setState(() => _languageFilter = l),
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
                      final filtered =
                          _applyFilters(state.results);
                      final List<PractitionerSearchResult> results =
                          _sortResults(filtered);
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
                          return SearchPractitionerCard(
                            practitioner: p,
                            onTap: () {
                              final fromPath = GoRouterState.of(
                                context,
                              ).uri.path;
                              final target = fromPath.startsWith('/home')
                                  ? '/home/practitioner/${p.id}'
                                  : '/practitioner/${p.id}';
                              context.push(target);
                            },
                            onBookTap: () {
                              context.push('/booking/${p.id}');
                            },
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
    required this.priceFilter,
    required this.onPriceFilterChanged,
    required this.languageFilter,
    required this.onLanguageFilterChanged,
  });

  final SortOption currentSort;
  final ValueChanged<SortOption> onSortChanged;
  final PriceRangeFilter priceFilter;
  final ValueChanged<PriceRangeFilter> onPriceFilterChanged;
  final String? languageFilter;
  final ValueChanged<String?> onLanguageFilterChanged;

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
                      style: TextStyle(
                        fontSize: 13.sp,
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
                          fontSize: 13.sp,
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
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: currentSort != SortOption.availability ||
                            priceFilter != PriceRangeFilter.all ||
                            languageFilter != null
                        ? AppColors.accent.withValues(alpha: 0.1)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10.r),
                    border: currentSort != SortOption.availability ||
                            priceFilter != PriceRangeFilter.all ||
                            languageFilter != null
                        ? Border.all(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            width: 1.r,
                          )
                        : null,
                  ),
                  child: Icon(
                    Icons.swap_vert_rounded,
                    color: currentSort != SortOption.availability
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    size: 18.sp,
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
                    color: priceFilter != PriceRangeFilter.all ||
                            languageFilter != null
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.primaryLightBackground,
                    borderRadius: BorderRadius.circular(10.r),
                    border: priceFilter != PriceRangeFilter.all ||
                            languageFilter != null
                        ? Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1.r,
                          )
                        : null,
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

  void _showSortMenu(BuildContext context) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
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
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
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
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
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
                          subtitle: l10n.searchSortAvailabilitySubtitle,
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
                          subtitle: l10n.searchSortDistanceSubtitle,
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
                          subtitle: l10n.searchSortNameSubtitle,
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
                          subtitle: l10n.searchSortRatingSubtitle,
                          isSelected: currentSort == SortOption.rating,
                          color: const Color(0xFFF59E0B),
                          onTap: () {
                            onSortChanged(SortOption.rating);
                            Navigator.of(ctx).pop();
                          },
                        ),
                        SizedBox(height: 8.h),
                        _SortOptionTile(
                          icon: Icons.payments_rounded,
                          label: l10n.searchSortPrice,
                          subtitle: l10n.searchSortPriceSubtitle,
                          isSelected: currentSort == SortOption.price,
                          color: AppColors.accent,
                          onTap: () {
                            onSortChanged(SortOption.price);
                            Navigator.of(ctx).pop();
                          },
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FilterBottomSheet(
        initialPriceFilter: priceFilter,
        initialLanguageFilter: languageFilter,
        onApply: (priceFilter, languageFilter) {
          onPriceFilterChanged(priceFilter);
          onLanguageFilterChanged(languageFilter);
          Navigator.of(ctx).pop();
        },
      ),
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
            color: isSelected
                ? color.withValues(alpha: 0.3)
                : AppColors.outline,
            width: isSelected ? 1.5.r : 1.r,
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
              child: Icon(icon, color: color, size: 20.sp),
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
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
  const _FilterBottomSheet({
    required this.initialPriceFilter,
    required this.initialLanguageFilter,
    required this.onApply,
  });

  final PriceRangeFilter initialPriceFilter;
  final String? initialLanguageFilter;
  final void Function(PriceRangeFilter priceFilter, String? languageFilter)
      onApply;

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String? _selectedDate;
  String? _selectedSpecialty;
  String? _selectedKupat;
  String? _selectedLanguage;
  double _maxDistance = 50;
  late PriceRangeFilter _priceFilter;

  String _getLanguageLabel(dynamic l10n, String key) {
    switch (key) {
      case 'practitionerLanguageHebrew':
        return l10n.practitionerLanguageHebrew;
      case 'practitionerLanguageFrench':
        return l10n.practitionerLanguageFrench;
      case 'practitionerLanguageEnglish':
        return l10n.practitionerLanguageEnglish;
      case 'practitionerLanguageRussian':
        return l10n.practitionerLanguageRussian;
      case 'practitionerLanguageSpanish':
        return l10n.practitionerLanguageSpanish;
      case 'practitionerLanguageAmharic':
        return l10n.practitionerLanguageAmharic;
      case 'practitionerLanguageArabic':
        return l10n.practitionerLanguageArabic;
      default:
        return key;
    }
  }

  static const List<({String code, String l10nKey})> _languageOptions = [
    (code: 'he', l10nKey: 'practitionerLanguageHebrew'),
    (code: 'fr', l10nKey: 'practitionerLanguageFrench'),
    (code: 'en', l10nKey: 'practitionerLanguageEnglish'),
    (code: 'ru', l10nKey: 'practitionerLanguageRussian'),
    (code: 'es', l10nKey: 'practitionerLanguageSpanish'),
    (code: 'am', l10nKey: 'practitionerLanguageAmharic'),
    (code: 'ar', l10nKey: 'practitionerLanguageArabic'),
  ];

  @override
  void initState() {
    super.initState();
    _priceFilter = widget.initialPriceFilter;
    _selectedLanguage = widget.initialLanguageFilter;
  }

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

  static const List<String> _kupatHolim = ['כללית', 'מכבי', 'מאוחדת', 'לאומית'];

  int get _activeFilterCount {
    int count = 0;
    if (_selectedDate != null) count++;
    if (_selectedSpecialty != null) count++;
    if (_selectedKupat != null) count++;
    if (_selectedLanguage != null) count++;
    if (_maxDistance < 50) count++;
    if (_priceFilter != PriceRangeFilter.all) count++;
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
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
          Divider(color: AppColors.outline, height: 1.h),
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
                          onTap: () => setState(() => _selectedDate = 'today'),
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
                            onTap: () => setState(() => _selectedSpecialty = s),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  // Language filter
                  _FilterSection(
                    title: l10n.searchFilterLanguage,
                    icon: Icons.translate_rounded,
                    iconColor: AppColors.primary,
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _FilterChip(
                          label: l10n.searchFilterLanguageAll,
                          isSelected: _selectedLanguage == null,
                          onTap: () =>
                              setState(() => _selectedLanguage = null),
                        ),
                        ..._languageOptions.map(
                          (opt) => _FilterChip(
                            label: _getLanguageLabel(l10n, opt.l10nKey),
                            isSelected: _selectedLanguage == opt.code,
                            onTap: () => setState(
                                () => _selectedLanguage = opt.code),
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
                  // Price filter
                  _FilterSection(
                    title: l10n.searchFilterPrice,
                    icon: Icons.payments_rounded,
                    iconColor: AppColors.accent,
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _FilterChip(
                          label: l10n.searchFilterPriceAll,
                          isSelected: _priceFilter == PriceRangeFilter.all,
                          onTap: () =>
                              setState(() => _priceFilter = PriceRangeFilter.all),
                        ),
                        _FilterChip(
                          label: l10n.searchFilterPriceUnder200,
                          isSelected:
                              _priceFilter == PriceRangeFilter.under200,
                          onTap: () => setState(
                              () => _priceFilter = PriceRangeFilter.under200),
                          accentColor: AppColors.accent,
                        ),
                        _FilterChip(
                          label: l10n.searchFilterPrice200_300,
                          isSelected:
                              _priceFilter == PriceRangeFilter.range200_300,
                          onTap: () => setState(
                              () => _priceFilter =
                                  PriceRangeFilter.range200_300),
                          accentColor: AppColors.accent,
                        ),
                        _FilterChip(
                          label: l10n.searchFilterPrice300_500,
                          isSelected:
                              _priceFilter == PriceRangeFilter.range300_500,
                          onTap: () => setState(
                              () => _priceFilter =
                                  PriceRangeFilter.range300_500),
                          accentColor: AppColors.accent,
                        ),
                        _FilterChip(
                          label: l10n.searchFilterPriceOver500,
                          isSelected:
                              _priceFilter == PriceRangeFilter.over500,
                          onTap: () => setState(
                              () => _priceFilter = PriceRangeFilter.over500),
                          accentColor: AppColors.accent,
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
                              style: Theme.of(context).textTheme.titleSmall
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
                            inactiveTrackColor: AppColors.primary.withValues(
                              alpha: 0.15,
                            ),
                            thumbColor: AppColors.primary,
                            overlayColor: AppColors.primary.withValues(
                              alpha: 0.1,
                            ),
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
                            onChanged: (v) => setState(() => _maxDistance = v),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1 ק"מ',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              Text(
                                '50+ ק"מ',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
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
                                _selectedLanguage = null;
                                _maxDistance = 50;
                                _priceFilter = PriceRangeFilter.all;
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
                      onPressed: () =>
                          widget.onApply(_priceFilter, _selectedLanguage),
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
              child: Icon(icon, size: 16.sp, color: iconColor),
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
            width: isSelected ? 1.5.r : 1.r,
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
