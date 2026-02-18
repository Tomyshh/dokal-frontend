import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../l10n/l10n.dart';
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
    final l10n = context.l10n;
    return BlocConsumer<HealthListCubit, HealthListState>(
      listener: (context, state) {
        if (state.status == HealthListStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? l10n.commonError)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: DokalAppBar(title: title),
          body: SafeArea(
            child: state.status == HealthListStatus.loading
                ? Padding(
                    padding: EdgeInsets.all(AppSpacing.lg.r),
                    child: const DokalLoader(lines: 5),
                  )
                : state.items.isEmpty
                ? DokalEmptyState(
                    title: emptyTitle,
                    subtitle: emptySubtitle,
                    icon: emptyIcon,
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(AppSpacing.lg.r),
                    itemCount: state.items.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: AppSpacing.sm.h),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return DokalCard(
                        padding: EdgeInsets.all(AppSpacing.md.r),
                        child: Row(
                          children: [
                            Container(
                              width: 32.r,
                              height: 32.r,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppRadii.sm.r,
                                ),
                              ),
                              child: Icon(
                                itemIcon,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: AppSpacing.md.w),
                            Expanded(
                              child: Text(
                                item.label,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'fab_health_list',
            onPressed: () => context.read<HealthListCubit>().addDemo(),
            child: Icon(Icons.add_rounded, size: 20.sp),
          ),
        );
      },
    );
  }
}
