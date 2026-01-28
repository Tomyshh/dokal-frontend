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
import '../bloc/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<SettingsCubit>(),
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state.status == SettingsStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? l10n.commonError)),
            );
          }
        },
        builder: (context, state) {
          final settings = state.settings;

          return Scaffold(
            appBar: DokalAppBar(title: l10n.commonSettings),
            body: SafeArea(
              child: state.status == SettingsStatus.loading
                  ? Padding(
                      padding: EdgeInsets.all(AppSpacing.lg.r),
                      child: const DokalLoader(lines: 5),
                    )
                  : settings == null
                  ? DokalEmptyState(
                      title: l10n.settingsUnavailableTitle,
                      subtitle: l10n.settingsUnavailableSubtitle,
                      icon: Icons.tune_rounded,
                    )
                  : ListView(
                      padding: EdgeInsets.all(AppSpacing.lg.r),
                      children: [
                        DokalCard(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md.w,
                            vertical: AppSpacing.xs.h,
                          ),
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              l10n.settingsNotificationsTitle,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            subtitle: Text(
                              l10n.settingsNotificationsSubtitle,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            value: settings.notificationsEnabled,
                            onChanged: (v) => context
                                .read<SettingsCubit>()
                                .setNotificationsEnabled(v),
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm.h),
                        DokalCard(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md.w,
                            vertical: AppSpacing.xs.h,
                          ),
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              l10n.settingsRemindersTitle,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            subtitle: Text(
                              l10n.settingsRemindersSubtitle,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            value: settings.remindersEnabled,
                            onChanged: (v) => context
                                .read<SettingsCubit>()
                                .setRemindersEnabled(v),
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm.h),
                        DokalCard(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg.w,
                            vertical: AppSpacing.md.h,
                          ),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              showDragHandle: true,
                              builder: (ctx) {
                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: Text(
                                          l10n.settingsLanguageTitle,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                        ),
                                        subtitle: Text(
                                          l10n.settingsLanguageCurrentLabel,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                        leading: const Icon(
                                          Icons.language_rounded,
                                          size: 20,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          l10n.commonAvailableSoon,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        leading: const Icon(
                                          Icons.info_outline_rounded,
                                          size: 20,
                                        ),
                                        onTap: () => Navigator.of(ctx).pop(),
                                      ),
                                      SizedBox(height: AppSpacing.sm.h),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.language_rounded, size: 20),
                              SizedBox(width: AppSpacing.md.w),
                              Expanded(
                                child: Text(
                                  l10n.settingsLanguageTitle,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              Text(
                                l10n.settingsLanguageShortLabel,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 18.sp,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
