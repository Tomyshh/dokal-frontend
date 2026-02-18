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
import '../../../../l10n/app_locale_controller.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const _supportedLanguages = [
    _LanguageOption(locale: Locale('he'), flag: '🇮🇱'),
    _LanguageOption(locale: Locale('en'), flag: '🇬🇧'),
    _LanguageOption(locale: Locale('fr'), flag: '🇫🇷'),
    _LanguageOption(locale: Locale('ru'), flag: '🇷🇺'),
    _LanguageOption(locale: Locale('am'), flag: '🇪🇹'),
    _LanguageOption(locale: Locale('es'), flag: '🇪🇸'),
  ];

  void _showLanguageBottomSheet(BuildContext context, dynamic l10n) {
    final currentLocale = AppLocaleController.locale.value;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                child: Row(
                  children: [
                    Icon(Icons.language_rounded, size: 20.sp),
                    SizedBox(width: AppSpacing.sm.w),
                    Text(
                      l10n.settingsLanguageTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),
              ..._supportedLanguages.map((lang) {
                final isSelected =
                    currentLocale.languageCode == lang.locale.languageCode;
                return ListTile(
                  leading: Text(lang.flag, style: TextStyle(fontSize: 22.sp)),
                  title: Text(
                    _languageName(l10n, lang.locale.languageCode),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 20.sp,
                        )
                      : null,
                  onTap: () {
                    AppLocaleController.setLocale(lang.locale);
                    Navigator.of(ctx).pop();
                  },
                );
              }),
              SizedBox(height: AppSpacing.md.h),
            ],
          ),
        );
      },
    );
  }

  static String _languageName(dynamic l10n, String code) {
    switch (code) {
      case 'he':
        return l10n.languageHebrew;
      case 'en':
        return l10n.languageEnglish;
      case 'fr':
        return l10n.languageFrench;
      case 'ru':
        return l10n.languageRussian;
      case 'am':
        return l10n.languageAmharic;
      case 'es':
        return l10n.languageSpanish;
      default:
        return code;
    }
  }

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
                            _showLanguageBottomSheet(context, l10n);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.language_rounded, size: 20.sp),
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

class _LanguageOption {
  const _LanguageOption({required this.locale, required this.flag});
  final Locale locale;
  final String flag;
}
