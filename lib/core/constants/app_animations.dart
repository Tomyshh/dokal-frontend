import 'package:flutter/material.dart';

/// Durées et courbes d'animation standardisées pour toute l'application.
///
/// Utilisation cohérente :
/// - `AppAnimations.fast` pour micro-interactions (hover, tap feedback)
/// - `AppAnimations.normal` pour transitions d'éléments UI
/// - `AppAnimations.slow` pour transitions de pages, apparitions
class AppAnimations {
  const AppAnimations._();

  // ── Durées ─────────────────────────────────────────────────────────────

  /// 150ms – micro-interactions (press, toggle)
  static const Duration fast = Duration(milliseconds: 150);

  /// 250ms – transitions standard (fade, slide d'éléments)
  static const Duration normal = Duration(milliseconds: 250);

  /// 350ms – transitions d'entrée / sortie de composants
  static const Duration medium = Duration(milliseconds: 350);

  /// 500ms – transitions de pages, apparitions complexes
  static const Duration slow = Duration(milliseconds: 500);

  /// 800ms – animations d'onboarding, hero animations
  static const Duration slower = Duration(milliseconds: 800);

  // ── Courbes ────────────────────────────────────────────────────────────

  /// Courbe par défaut pour les entrées (ease out)
  static const Curve easeOut = Curves.easeOutCubic;

  /// Courbe pour les sorties (ease in)
  static const Curve easeIn = Curves.easeInCubic;

  /// Courbe pour les transitions bidirectionnelles
  static const Curve ease = Curves.easeInOutCubic;

  /// Courbe rebondissante pour les micro-interactions ludiques
  static const Curve bounce = Curves.easeOutBack;

  /// Courbe douce pour le défilement / staggered animations
  static const Curve gentle = Curves.easeOutQuart;

  // ── Staggered delays ───────────────────────────────────────────────────

  /// Délai entre chaque élément dans une animation séquentielle (staggered).
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Calcule le délai pour l'élément à l'[index] dans une liste.
  static Duration staggerDelayFor(int index) =>
      Duration(milliseconds: 50 * index);

  // ── Page transitions ───────────────────────────────────────────────────

  /// Transition de page standard (slide + fade)
  static Widget slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final offsetTween = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).chain(CurveTween(curve: easeOut));
    final fadeTween = Tween<double>(begin: 0, end: 1).chain(
      CurveTween(curve: easeOut),
    );

    return SlideTransition(
      position: animation.drive(offsetTween),
      child: FadeTransition(
        opacity: animation.drive(fadeTween),
        child: child,
      ),
    );
  }
}
