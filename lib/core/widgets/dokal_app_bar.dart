import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_text_styles.dart';
import '../../l10n/l10n.dart';

/// AppBar moderne Dokal avec bouton retour stylisé.
class DokalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DokalAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = true,
    this.onBack,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.background;
    final effectiveFg = foregroundColor ?? AppColors.textPrimary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    Widget? titleWidget;
    if (subtitle != null) {
      titleWidget = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMd(color: effectiveFg),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle!,
            style: AppTextStyles.bodyXs(
              color: effectiveFg.withValues(alpha: 0.7),
            ),
          ),
        ],
      );
    } else {
      titleWidget = Text(
        title,
        style: AppTextStyles.titleLg(color: effectiveFg),
      );
    }

    return AppBar(
      backgroundColor: effectiveBg,
      foregroundColor: effectiveFg,
      elevation: elevation,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? Padding(
              padding: EdgeInsetsDirectional.only(start: 4.w),
              child: IconButton(
                onPressed: () => _handleBack(context),
                icon: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: effectiveFg.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadii.lg.r),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Icon(
                      isRtl
                          ? Icons.arrow_forward_ios_rounded
                          : Icons.arrow_back_ios_new_rounded,
                      size: 16.sp,
                      color: effectiveFg,
                    ),
                  ),
                ),
                tooltip: context.l10n.commonBack,
              ),
            )
          : null,
      title: titleWidget,
      actions: actions,
      bottom: bottom,
    );
  }
}
