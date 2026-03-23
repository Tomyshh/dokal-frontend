import 'package:flutter/material.dart';

import '../constants/app_animations.dart';

/// Widget d'animation d'apparition avec slide + fade.
///
/// Parfait pour les listes staggered :
/// ```dart
/// for (int i = 0; i < items.length; i++)
///   DokalFadeIn(
///     delay: AppAnimations.staggerDelayFor(i),
///     child: MyCard(item: items[i]),
///   )
/// ```
class DokalFadeIn extends StatefulWidget {
  const DokalFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration,
    this.curve,
    this.slideOffset = 0.03,
  });

  final Widget child;
  final Duration delay;
  final Duration? duration;
  final Curve? curve;

  /// Décalage vertical initial (fraction de la hauteur parente). Par défaut 3%.
  final double slideOffset;

  @override
  State<DokalFadeIn> createState() => _DokalFadeInState();
}

class _DokalFadeInState extends State<DokalFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? AppAnimations.medium,
      vsync: this,
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? AppAnimations.easeOut,
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(curve);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffset),
      end: Offset.zero,
    ).animate(curve);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _opacity,
        child: widget.child,
      ),
    );
  }
}
