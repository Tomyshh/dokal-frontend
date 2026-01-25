import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../core/widgets/practitioner_card.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/practitioner_search_result.dart';
import '../bloc/search_cubit.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: Scaffold(
        appBar: const DokalAppBar(title: 'Rechercher'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                        size: 22,
                      ),
                      const SizedBox(width: 12),
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
                                hintText: 'Praticien, spécialité...',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintStyle: TextStyle(
                                  fontSize: 15,
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
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLightBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state.status == SearchStatus.loading) {
                        return const Padding(
                          padding: EdgeInsets.only(top: AppSpacing.sm),
                          child: DokalLoader(lines: 6),
                        );
                      }
                      if (state.status == SearchStatus.failure) {
                        return DokalEmptyState(
                          title: 'Recherche indisponible',
                          subtitle: state.error ?? 'Réessayez plus tard.',
                          icon: Icons.search_off_rounded,
                        );
                      }
                      final List<PractitionerSearchResult> results = state.results;
                      if (results.isEmpty) {
                        return const DokalEmptyState(
                          title: 'Aucun résultat',
                          subtitle: 'Essayez avec un autre terme.',
                          icon: Icons.search_rounded,
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        itemCount: results.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final p = results[index];
                          return PractitionerCard(
                            name: p.name,
                            specialty: p.specialty,
                            address: p.address,
                            sector: p.sector,
                            nextAvailabilityLabel: p.nextAvailabilityLabel,
                            distanceLabel: p.distanceLabel,
                            onTap: () => context.go('/practitioner/${p.id}'),
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

