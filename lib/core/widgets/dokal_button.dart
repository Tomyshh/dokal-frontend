import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_text_styles.dart';

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

  factory DokalButton.text({
    required VoidCallback? onPressed,
    required Widget child,
    bool isLoading = false,
    Widget? leading,
    bool compact = false,
  }) => DokalButton._(
    onPressed: onPressed,
    variant: _Variant.text,
    isLoading: isLoading,
    leading: leading,
    compact: compact,
    child: child,
  );

  /// Bouton doré premium — CTA de connexion / actions importantes.
  factory DokalButton.gold({
    required VoidCallback? onPressed,
    required Widget child,
    bool isLoading = false,
    Widget? leading,
    bool compact = false,
  }) => DokalButton._(
    onPressed: onPressed,
    variant: _Variant.gold,
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
    final hPadding = (compact ? 14.0 : 20.0).w;
    final vPadding = (compact ? 10.0 : 14.0).h;

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
              color: _variant == _Variant.primary || _variant == _Variant.gold
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
            style: compact
                ? AppTextStyles.labelSm()
                : AppTextStyles.labelMd(),
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
        Size(compact ? 0 : double.infinity, (compact ? 38.0 : 48.0).h),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
        ),
      ),
      elevation: const WidgetStatePropertyAll(0),
      textStyle: WidgetStatePropertyAll(
        compact ? AppTextStyles.labelSm() : AppTextStyles.labelMd(),
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
      case _Variant.text:
        button = TextButton(
          style: style.copyWith(
            foregroundColor: const WidgetStatePropertyAll(AppColors.primary),
          ),
          onPressed: effectiveOnPressed,
          child: content,
        );
      case _Variant.gold:
        button = _GoldShimmerButton(
          style: style,
          onPressed: effectiveOnPressed,
          child: content,
        );
    }

    if (compact) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

enum _Variant { primary, secondary, outline, text, gold }

// ─────────────────────────────────────────────────────────────────────────────
// GOLD SHIMMER BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _GoldShimmerButton extends StatefulWidget {
  const _GoldShimmerButton({
    required this.style,
    required this.onPressed,
    required this.child,
  });

  final ButtonStyle style;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<_GoldShimmerButton> createState() => _GoldShimmerButtonState();
}

class _GoldShimmerButtonState extends State<_GoldShimmerButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;

  // Palette dorée riche
  static const _goldLight = Color(0xFFE8C55A);
  static const _gold = Color(0xFFD4A843);
  static const _goldDark = Color(0xFFB8922E);
  static const _goldDeep = Color(0xFFA07B24);

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    // Délai avant le shimmer pour laisser le bouton apparaître
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _shimmerCtrl.forward();
    });
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (context, child) {
        final shimmerValue = _shimmerCtrl.value;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_goldLight, _gold, _goldDark, _goldDeep],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
            borderRadius: BorderRadius.circular(AppRadii.lg.r),
            boxShadow: [
              BoxShadow(
                color: _gold.withValues(alpha: 0.35),
                blurRadius: 14.r,
                offset: Offset(0, 5.h),
              ),
              BoxShadow(
                color: _goldLight.withValues(alpha: 0.15),
                blurRadius: 6.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.lg.r),
            child: Stack(
              children: [
                // Shimmer highlight pass
                if (shimmerValue > 0 && shimmerValue < 1)
                  Positioned.fill(
                    child: FractionallySizedBox(
                      alignment: Alignment(
                        -1.0 + 2.0 * shimmerValue,
                        0,
                      ),
                      widthFactor: 0.4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.28),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                // Le bouton réel
                child!,
              ],
            ),
          ),
        );
      },
      child: FilledButton(
        style: widget.style.copyWith(
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
        ),
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}
