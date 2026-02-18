import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';

/// Bouton moderne Dokal avec variantes et taille compacte.
class DokalButton extends StatelessWidget {
  const DokalButton._({
    required this.onPressed,
    required this.child,
    required _Variant variant,
    this.isLoading = false,
    this.leading,
    this.compact = false,
  }) : _variant = variant;

  factory DokalButton.primary({
    required VoidCallback? onPressed,
    required Widget child,
    bool isLoading = false,
    Widget? leading,
    bool compact = false,
  }) => DokalButton._(
    onPressed: onPressed,
    variant: _Variant.primary,
    isLoading: isLoading,
    leading: leading,
    compact: compact,
    child: child,
  );

  factory DokalButton.secondary({
    required VoidCallback? onPressed,
    required Widget child,
    bool isLoading = false,
    Widget? leading,
    bool compact = false,
  }) => DokalButton._(
    onPressed: onPressed,
    variant: _Variant.secondary,
    isLoading: isLoading,
    leading: leading,
    compact: compact,
    child: child,
  );

  factory DokalButton.outline({
    required VoidCallback? onPressed,
    required Widget child,
    bool isLoading = false,
    Widget? leading,
    bool compact = false,
  }) => DokalButton._(
    onPressed: onPressed,
    variant: _Variant.outline,
    isLoading: isLoading,
    leading: leading,
    compact: compact,
    child: child,
  );

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Widget? leading;
  final bool compact;
  final _Variant _variant;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final iconSize = (compact ? 14.0 : 16.0).sp;
    final loaderSize = (compact ? 14.0 : 16.0).r;
    final hPadding = (compact ? 12.0 : 16.0).w;
    final vPadding = (compact ? 10.0 : 12.0).h;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: loaderSize,
            height: loaderSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.r,
              color: _variant == _Variant.primary
                  ? Colors.white
                  : AppColors.primary,
            ),
          ),
          SizedBox(width: 8.w),
        ] else if (leading != null) ...[
          IconTheme(
            data: IconThemeData(size: iconSize),
            child: leading!,
          ),
          SizedBox(width: 8.w),
        ],
        Flexible(
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: (compact ? 12.0 : 13.0).sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
            child: child,
          ),
        ),
      ],
    );

    final style = ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      ),
      minimumSize: WidgetStatePropertyAll(
        Size(compact ? 0 : double.infinity, (compact ? 36.0 : 44.0).h),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md.r),
        ),
      ),
      elevation: const WidgetStatePropertyAll(0),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: 'Inter',
          fontSize: (compact ? 12.0 : 13.0).sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    Widget button;
    switch (_variant) {
      case _Variant.primary:
        button = FilledButton(
          style: style,
          onPressed: effectiveOnPressed,
          child: content,
        );
      case _Variant.secondary:
        button = FilledButton.tonal(
          style: style,
          onPressed: effectiveOnPressed,
          child: content,
        );
      case _Variant.outline:
        button = OutlinedButton(
          style: style.copyWith(
            side: const WidgetStatePropertyAll(
              BorderSide(color: AppColors.outline),
            ),
          ),
          onPressed: effectiveOnPressed,
          child: content,
        );
    }

    if (compact) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

enum _Variant { primary, secondary, outline }
