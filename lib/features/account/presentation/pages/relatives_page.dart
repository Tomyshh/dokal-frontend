import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/relative.dart';
import '../bloc/relatives_cubit.dart';

class RelativesPage extends StatelessWidget {
  const RelativesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<RelativesCubit>(),
      child: BlocConsumer<RelativesCubit, RelativesState>(
        listener: (context, state) {
          if (state.status == RelativesStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? l10n.commonError)),
            );
          }
        },
        builder: (context, state) {
          final List<Relative> relatives = state.items;
          return Scaffold(
            appBar: DokalAppBar(title: l10n.relativesTitle),
            body: SafeArea(
              child: state.status == RelativesStatus.loading
                  ? Padding(
                      padding: EdgeInsets.all(AppSpacing.lg.r),
                      child: const DokalLoader(lines: 5),
                    )
                  : relatives.isEmpty
                  ? DokalEmptyState(
                      title: l10n.relativesEmptyTitle,
                      subtitle: l10n.relativesEmptySubtitle,
                      icon: Icons.group_rounded,
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(AppSpacing.lg.r),
                      itemCount: relatives.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSpacing.sm.h),
                      itemBuilder: (context, index) {
                        final r = relatives[index];
                        return DokalCard(
                          padding: EdgeInsets.all(AppSpacing.md.r),
                          child: Row(
                            children: [
                              Container(
                                width: 36.r,
                                height: 36.r,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 18.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: AppSpacing.md.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      r.label,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 18.sp,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            floatingActionButton: FloatingActionButton.small(
              heroTag: 'fab_relatives',
              onPressed: () => context.read<RelativesCubit>().addDemo(),
              child: Icon(Icons.add_rounded, size: 20.sp),
            ),
          );
        },
      ),
    );
  }
}
