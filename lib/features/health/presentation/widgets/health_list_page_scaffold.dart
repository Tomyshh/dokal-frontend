import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../bloc/health_list_cubit.dart';

/// Scaffold réutilisable pour les pages de liste de santé.
class HealthListPageScaffold extends StatelessWidget {
  const HealthListPageScaffold({
    super.key,
    required this.title,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
    required this.itemIcon,
  });

  final String title;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final IconData itemIcon;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HealthListCubit, HealthListState>(
      listener: (context, state) {
        if (state.status == HealthListStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? 'Erreur')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: DokalAppBar(title: title),
          body: SafeArea(
            child: state.status == HealthListStatus.loading
                ? const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: DokalLoader(lines: 5),
                  )
                : state.items.isEmpty
                    ? DokalEmptyState(
                        title: emptyTitle,
                        subtitle: emptySubtitle,
                        icon: emptyIcon,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: state.items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return DokalCard(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(AppRadii.sm),
                                  ),
                                  child: Icon(
                                    itemIcon,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          floatingActionButton: FloatingActionButton.small(
            onPressed: () => context.read<HealthListCubit>().addDemo(),
            child: const Icon(Icons.add_rounded, size: 20),
          ),
        );
      },
    );
  }
}
