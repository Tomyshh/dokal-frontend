import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
    } else if (context.canPop()) {
      context.pop();
    } else {
      // Fallback: go to home
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.background;
    final effectiveFg = foregroundColor ?? AppColors.textPrimary;
    final showBack = showBackButton;

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
            style: TextStyle(
              color: effectiveFg,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          Text(
            subtitle!,
            style: TextStyle(
              color: effectiveFg.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    } else {
      titleWidget = Text(
        title,
        style: TextStyle(
          color: effectiveFg,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return AppBar(
      backgroundColor: effectiveBg,
      foregroundColor: effectiveFg,
      elevation: elevation,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: showBack
          ? Padding(
              padding: const EdgeInsets.only(left: 4),
              child: IconButton(
                onPressed: () => _handleBack(context),
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: effectiveFg.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: effectiveFg,
                  ),
                ),
                tooltip: context.l10n.commonBack,
              ),
            )
          : null,
      title: titleWidget,
      actions: actions,
    );
  }
}
