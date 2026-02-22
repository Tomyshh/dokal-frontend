import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_avatar.dart';
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
          final profile = state.profile;
          final hasContent = profile != null || relatives.isNotEmpty;
          return Scaffold(
            appBar: DokalAppBar(title: l10n.relativesTitle),
            body: SafeArea(
              child: state.status == RelativesStatus.loading
                  ? Padding(
                      padding: EdgeInsets.all(AppSpacing.lg.r),
                      child: const DokalLoader(lines: 5),
                    )
                  : !hasContent
                  ? DokalEmptyState(
                      title: l10n.relativesEmptyTitle,
                      subtitle: l10n.relativesEmptySubtitle,
                      icon: Icons.group_rounded,
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(AppSpacing.lg.r),
                      itemCount: (profile != null ? 1 : 0) + relatives.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSpacing.sm.h),
                      itemBuilder: (context, index) {
                        if (profile != null && index == 0) {
                          final year = profile.dateOfBirth != null &&
                                  profile.dateOfBirth!.length >= 4
                              ? profile.dateOfBirth!.substring(0, 4)
                              : '';
                          final label = year.isNotEmpty
                              ? '${l10n.relativesMeCardLabel} • $year'
                              : l10n.relativesMeCardLabel;
                          return _buildMemberCard(
                            context,
                            name: profile.fullName,
                            label: label,
                            avatarUrl: profile.avatarUrl,
                            onTap: () async {
                              await context.push('/account/edit-profile');
                              if (context.mounted) {
                                context.read<RelativesCubit>().load();
                              }
                            },
                          );
                        }
                        final r = relatives[profile != null ? index - 1 : index];
                        final relationLabel = l10n.relationLabel(r.relation ?? 'other');
                        final year = r.dateOfBirth != null &&
                                r.dateOfBirth!.length >= 4
                            ? r.dateOfBirth!.substring(0, 4)
                            : '';
                        final label = year.isNotEmpty
                            ? '$relationLabel • $year'
                            : relationLabel;
                        return _buildMemberCard(
                          context,
                          name: r.name,
                          label: label,
                          avatarUrl: r.avatarUrl,
                          onTap: () async {
                            await context.push(
                              '/account/relatives/edit',
                              extra: r,
                            );
                            if (context.mounted) {
                              context.read<RelativesCubit>().load();
                            }
                          },
                        );
                      },
                    ),
            ),
            floatingActionButton: FloatingActionButton.small(
              heroTag: 'fab_relatives',
              onPressed: () async {
                await context.push('/account/relatives/add');
                if (context.mounted) {
                  context.read<RelativesCubit>().load();
                }
              },
              child: Icon(Icons.add_rounded, size: 20.sp),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMemberCard(
    BuildContext context, {
    required String name,
    String? label,
    String? avatarUrl,
    VoidCallback? onTap,
  }) {
    return DokalCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          children: [
            _buildAvatar(context, name: name, avatarUrl: avatarUrl),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (label != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: 18.sp,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context,
      {required String name, String? avatarUrl}) {
    if (avatarUrl != null && avatarUrl.trim().isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: 36.r,
          height: 36.r,
          child: Image.network(
            avatarUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                DokalAvatar(name: name, size: 36),
          ),
        ),
      );
    }
    return DokalAvatar(name: name, size: 36);
  }
}
