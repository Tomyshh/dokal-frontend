import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Titre de section réutilisable avec action optionnelle.
///
/// Utilisé dans Home, Appointments, Account, etc. pour séparer
/// visuellement les blocs de contenu.
class DokalSectionTitle extends StatelessWidget {
  const DokalSectionTitle({
    super.key,
    required this.title,
    this.action,
    this.actionLabel,
    this.onAction,
    this.padding,
  });

  final String title;

  /// Widget d'action personnalisé (prioritaire sur [actionLabel] / [onAction]).
  final Widget? action;

  /// Label textuel pour un bouton d'action simple (ex : "Voir tout").
  final String? actionLabel;

  /// Callback du bouton d'action textuel.
  final VoidCallback? onAction;

  /// Padding externe (par défaut aucun).
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Expanded(
          child: Text(title, style: AppTextStyles.titleLg()),
        ),
        if (action != null) action!,
        if (action == null && actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: AppTextStyles.labelSm(color: AppColors.primary),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(actionLabel!),
          ),
      ],
    );

    if (padding == null) return content;
    return Padding(padding: padding!, child: content);
  }
}
