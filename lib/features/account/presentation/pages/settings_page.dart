import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../bloc/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>(),
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state.status == SettingsStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Erreur')),
            );
          }
        },
        builder: (context, state) {
          final settings = state.settings;

          return Scaffold(
            appBar: const DokalAppBar(title: 'Paramètres'),
            body: SafeArea(
              child: state.status == SettingsStatus.loading
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: DokalLoader(lines: 5),
                    )
                  : settings == null
                      ? const DokalEmptyState(
                          title: 'Paramètres indisponibles',
                          subtitle: "Impossible de charger vos préférences.",
                          icon: Icons.tune_rounded,
                        )
                      : ListView(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          children: [
                            DokalCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              child: SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Notifications',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                subtitle: Text(
                                  'Recevoir des messages et mises à jour',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                value: settings.notificationsEnabled,
                                onChanged: (v) => context
                                    .read<SettingsCubit>()
                                    .setNotificationsEnabled(v),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            DokalCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              child: SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Rappels de rendez-vous',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                subtitle: Text(
                                  'Recevoir des rappels avant vos RDV',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                value: settings.remindersEnabled,
                                onChanged: (v) => context
                                    .read<SettingsCubit>()
                                    .setRemindersEnabled(v),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            DokalCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
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
                                              'Langue',
                                              style: Theme.of(context).textTheme.titleSmall,
                                            ),
                                            subtitle: Text(
                                              'Français (actuel)',
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                            leading: const Icon(Icons.language_rounded, size: 20),
                                          ),
                                          ListTile(
                                            title: Text(
                                              'Bientôt disponible',
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                            leading: const Icon(Icons.info_outline_rounded, size: 20),
                                            onTap: () => Navigator.of(ctx).pop(),
                                          ),
                                          const SizedBox(height: AppSpacing.sm),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.language_rounded, size: 20),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(
                                      'Langue',
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ),
                                  Text(
                                    'Français',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 18,
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

