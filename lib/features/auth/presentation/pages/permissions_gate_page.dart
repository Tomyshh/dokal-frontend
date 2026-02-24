import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/permissions/permissions_service.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';

/// Page obligatoire après l'onboarding : l'utilisateur doit activer les switches
/// notifications et localisation pour continuer. Barrière persistante (même après restart).
class PermissionsGatePage extends StatefulWidget {
  const PermissionsGatePage({super.key});

  @override
  State<PermissionsGatePage> createState() => _PermissionsGatePageState();
}

class _PermissionsGatePageState extends State<PermissionsGatePage> {
  bool _notificationsEnabled = false;
  bool _locationEnabled = false;
  bool _isValidating = false;

  bool get _canValidate => _notificationsEnabled && _locationEnabled;

  Future<void> _toggleNotifications() async {
    if (_notificationsEnabled) {
      setState(() => _notificationsEnabled = false);
      return;
    }
    final permissionsService = sl<PermissionsService>();
    final pushService = sl<PushNotificationService>();
    final granted = await permissionsService.requestNotifications();
    if (!mounted) return;
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorNotificationPermissionDenied)),
      );
      return;
    }
    final pushGranted = await pushService.requestPermission();
    if (!mounted) return;
    if (!pushGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorNotificationPermissionDenied)),
      );
      return;
    }
    await pushService.getToken();
    if (mounted) setState(() => _notificationsEnabled = true);
  }

  Future<void> _toggleLocation() async {
    if (_locationEnabled) {
      setState(() => _locationEnabled = false);
      return;
    }
    final granted = await sl<PermissionsService>().requestLocation();
    if (!mounted) return;
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.permissionsGateLocationDenied)),
      );
      return;
    }
    setState(() => _locationEnabled = true);
  }

  Future<void> _validate() async {
    if (!_canValidate || _isValidating) return;

    setState(() => _isValidating = true);

    final prefs = sl<SharedPreferences>();
    final pushService = sl<PushNotificationService>();

    try {
      // Les permissions ont déjà été demandées au toggle des switches, on vérifie juste l'état.
      if (!_notificationsEnabled || !_locationEnabled) return;
      await pushService.getToken();

      // Marquer comme complété et rediriger
      await prefs.setBool('permissions_completed', true);
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.commonError)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isValidating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
                AppColors.primaryDark,
                AppColors.primary,
              ],
              stops: const [0.0, 0.35, 0.65, 1.0],
            ),
          ),
          child: SafeArea(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Bulles décoratives (positionnées pour éviter les coupures)
                Positioned(
                  top: 0,
                  left: 0,
                  child: _Bubble(size: 100.r, opacity: 0.12),
                ),
                Positioned(
                  top: 120.h,
                  right: -40.w,
                  child: _Bubble(size: 100.r, opacity: 0.1),
                ),
                Positioned(
                  bottom: 180.h,
                  left: -25.w,
                  child: _Bubble(size: 80.r, opacity: 0.08),
                ),
                Positioned(
                  bottom: 80.h,
                  right: -20.w,
                  child: _Bubble(size: 90.r, opacity: 0.1),
                ),
                // Contenu
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.xxl.h),
                      // Logo
                      Container(
                        padding: EdgeInsets.all(AppSpacing.md.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Image.asset(
                          'assets/branding/icononly_transparent_nobuffer.png',
                          height: 64.h,
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxl.h),
                      Text(
                        l10n.permissionsGateTitle,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      Text(
                        l10n.permissionsGateSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.35,
                          fontSize: 15.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.xxl.h),
                      // Carte notifications
                      _PermissionCard(
                        icon: Icons.notifications_rounded,
                        title: l10n.permissionsGateNotificationsTitle,
                        subtitle: l10n.permissionsGateNotificationsSubtitle,
                        value: _notificationsEnabled,
                        onTap: _toggleNotifications,
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      // Carte localisation
                      _PermissionCard(
                        icon: Icons.location_on_rounded,
                        title: l10n.permissionsGateLocationTitle,
                        subtitle: l10n.permissionsGateLocationSubtitle,
                        value: _locationEnabled,
                        onTap: _toggleLocation,
                      ),
                      const Spacer(),
                      // Bouton Valider
                      Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.xl.h),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _canValidate && !_isValidating ? _validate : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              disabledBackgroundColor: Colors.white.withValues(alpha: 0.4),
                              disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 14.h,
                              ),
                              minimumSize: Size(double.infinity, 50.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: _isValidating
                                ? SizedBox(
                                    height: 22.h,
                                    width: 22.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : Text(
                                    l10n.permissionsGateValidateButton,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
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

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        splashColor: Colors.white.withValues(alpha: 0.2),
        highlightColor: Colors.white.withValues(alpha: 0.1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg.w,
                vertical: AppSpacing.md.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(icon, size: 24.sp, color: Colors.white),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.25,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      switchTheme: SwitchThemeData(
                        thumbColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) return Colors.white;
                          return null;
                        }),
                        trackColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.brandGradientHighlight.withValues(alpha: 0.7);
                          }
                          return Colors.white.withValues(alpha: 0.3);
                        }),
                      ),
                    ),
                    child: Switch(
                      value: value,
                      onChanged: (_) => onTap(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
