import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/relative.dart';
import '../bloc/relatives_cubit.dart';

class RelativesPage extends StatelessWidget {
  const RelativesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RelativesCubit>(),
      child: BlocConsumer<RelativesCubit, RelativesState>(
        listener: (context, state) {
          if (state.status == RelativesStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Erreur')),
            );
          }
        },
        builder: (context, state) {
          final List<Relative> relatives = state.items;
          return Scaffold(
            appBar: const DokalAppBar(title: 'Mes proches'),
            body: SafeArea(
              child: state.status == RelativesStatus.loading
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: DokalLoader(lines: 5),
                    )
                  : relatives.isEmpty
                      ? const DokalEmptyState(
                          title: 'Aucun proche',
                          subtitle:
                              'Ajoutez vos proches pour prendre RDV en leur nom.',
                          icon: Icons.group_rounded,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          itemCount: relatives.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final r = relatives[index];
                            return DokalCard(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          r.label,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
            floatingActionButton: FloatingActionButton.small(
              onPressed: () => context.read<RelativesCubit>().addDemo(),
              child: const Icon(Icons.add_rounded, size: 20),
            ),
          );
        },
      ),
    );
  }
}

