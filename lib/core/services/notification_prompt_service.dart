import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../permissions/permissions_service.dart';
import '../services/push_notification_service.dart';
import '../../injection_container.dart';
import '../../l10n/l10n.dart';

/// Clé SharedPreferences mémorisant combien de fois le prompt a été affiché.
const _kPromptShownCountKey = 'notification_prompt_shown_count';

/// Nombre max d'affichages du prompt avant d'arrêter de déranger l'utilisateur.
const _kMaxPromptShownCount = 3;

/// Service responsable d'afficher, au bon moment, une demande contextuelle
/// d'activation des notifications (iOS uniquement).
class NotificationPromptService {
  /// Retourne `true` si le prompt doit être affiché :
  /// - Uniquement sur iOS
  /// - Seulement si la permission n'est pas encore accordée
  /// - Pas plus de [_kMaxPromptShownCount] fois
  static Future<bool> shouldShow() async {
    if (!Platform.isIOS) return false;

    final status = await Permission.notification.status;
    if (status.isGranted) return false;
    // Si l'utilisateur a définitivement refusé dans les réglages, on n'insiste plus.
    if (status.isPermanentlyDenied) return false;

    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_kPromptShownCountKey) ?? 0;
    return count < _kMaxPromptShownCount;
  }

  /// Affiche le bottom sheet de prompt et retourne `true` si l'utilisateur
  /// a accordé la permission.
  static Future<bool> show(BuildContext context) async {
    if (!await shouldShow()) return false;

    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_kPromptShownCountKey) ?? 0;
    await prefs.setInt(_kPromptShownCountKey, count + 1);

    if (!context.mounted) return false;

    final granted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _NotificationPromptSheet(),
    );

    return granted == true;
  }
}

class _NotificationPromptSheet extends StatefulWidget {
  const _NotificationPromptSheet();

  @override
  State<_NotificationPromptSheet> createState() =>
      _NotificationPromptSheetState();
}

class _NotificationPromptSheetState extends State<_NotificationPromptSheet> {
  bool _loading = false;

  Future<void> _onAllow() async {
    setState(() => _loading = true);
    try {
      final permissionsService = sl<PermissionsService>();
      final pushService = sl<PushNotificationService>();
      final granted = await permissionsService.requestNotifications();
      if (!mounted) return;
      if (granted) {
        await pushService.requestPermission();
        await pushService.getToken();
      }
      if (mounted) Navigator.of(context).pop(granted);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSkip() => Navigator.of(context).pop(false);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl.w,
        AppSpacing.lg.h,
        AppSpacing.xl.w,
        AppSpacing.xl.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Poignée
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(99.r),
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          // Icône
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.brandGradientStart,
                  AppColors.brandGradientEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 16.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          Text(
            l10n.notificationPromptTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            l10n.notificationPromptBody,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xl.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _loading ? null : _onAllow,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: _loading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      l10n.notificationPromptAllow,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          TextButton(
            onPressed: _onSkip,
            child: Text(
              l10n.notificationPromptSkip,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
