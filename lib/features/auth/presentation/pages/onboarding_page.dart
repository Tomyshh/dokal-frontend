import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:country_flags/country_flags.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/app_locale_controller.dart';
import '../bloc/onboarding_cubit.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _nextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pages = [
      _OnboardingStep(
        title: l10n.onboardingStep1Title,
        imagePath: 'assets/images/onboarding_1.jpeg',
      ),
      _OnboardingStep(
        title: l10n.onboardingStep2Title,
        subtitle: l10n.onboardingStep2Subtitle,
        imagePath: 'assets/images/onboarding_2.jpeg',
      ),
      _OnboardingStep(
        title: l10n.onboardingStep3Title,
        subtitle: l10n.onboardingStep3Subtitle,
        imagePath: 'assets/images/onboarding_3.jpeg',
      ),
    ];
    final isLast = _currentPage == pages.length - 1;

    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state.status == OnboardingStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? l10n.commonError)),
            );
          }
          if (state.status == OnboardingStatus.success && state.completed) {
            context.go('/home');
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: AppSpacing.lg.h),
                // Barre de progression segmentée
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
                  child: _ProgressBar(
                    totalSteps: pages.length,
                    currentStep: _currentPage,
                  ),
                ),
                SizedBox(height: AppSpacing.xxl.h),
                // Logo Dokal
                const _DokalLogo(),
                SizedBox(height: AppSpacing.lg.h),
                // Contenu scrollable
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxH = constraints.maxHeight;
                      final minArt = 320.0.h;
                      // Au premier frame, maxH peut être < minArt (safe area non appliquée) :
                      // clamp(min, max) exige min <= max.
                      final safeMinArt = minArt <= maxH ? minArt : maxH;
                      final artHeight = (maxH * 0.62).clamp(safeMinArt, maxH);
                      final topAreaHeight = (maxH - artHeight).clamp(0.0, maxH);

                      return Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: artHeight,
                              width: double.infinity,
                              child: _PersistentOnboardingArt(
                                controller: _controller,
                                imagePaths: pages.map((p) => p.imagePath).toList(),
                              ),
                            ),
                          ),
                          PageView.builder(
                            controller: _controller,
                            itemCount: pages.length,
                            onPageChanged: _onPageChanged,
                            itemBuilder: (context, index) {
                              final step = pages[index];
                              return _OnboardingTextPage(
                                step: step,
                                controller: _controller,
                                pageIndex: index,
                                showLanguagePicker: index == 0,
                                topAreaHeight: topAreaHeight,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Bouton en bas (blanc, texte primary)
                Padding(
                  padding: EdgeInsets.all(AppSpacing.xl.r),
                  child: BlocBuilder<OnboardingCubit, OnboardingState>(
                    builder: (context, state) {
                      final isLoading =
                          state.status == OnboardingStatus.loading;
                      return SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (!isLast) {
                                    _nextPage();
                                    return;
                                  }
                                  context.read<OnboardingCubit>().complete();
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            disabledBackgroundColor: Colors.white.withValues(alpha: 0.6),
                            disabledForegroundColor: AppColors.primary.withValues(alpha: 0.6),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            minimumSize: Size(double.infinity, 44.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : Text(
                                  isLast
                                      ? l10n.onboardingStartButton
                                      : l10n.onboardingContinueButton,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
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

/// Barre de progression segmentée style Doctolib
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.totalSteps, required this.currentStep});

  final int totalSteps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        final isFirst = index == 0;
        final isLast = index == totalSteps - 1;

        return Expanded(
          child: Container(
            height: 4.h,
            margin: EdgeInsets.only(
              left: isFirst ? 0 : 4.w,
              right: isLast ? 0 : 4.w,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        );
      }),
    );
  }
}

/// Logo Dokal
class _DokalLogo extends StatelessWidget {
  const _DokalLogo();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF1B8), // highlight
            Color(0xFFFFD166), // gold
            Color(0xFFB8860B), // deep gold
          ],
          stops: [0.0, 0.45, 1.0],
        ).createShader(rect);
      },
      child: Image.asset(
        'assets/branding/icononly_transparent_nobuffer.png',
        height: 56.h,
        fit: BoxFit.contain,
        // Garder l'image "blanche" pour appliquer le shader proprement.
        color: Colors.white,
      ),
    );
  }
}

/// Contenu d'une étape d'onboarding
class _OnboardingTextPage extends StatelessWidget {
  const _OnboardingTextPage({
    required this.step,
    required this.controller,
    required this.pageIndex,
    required this.topAreaHeight,
    this.showLanguagePicker = false,
  });

  final _OnboardingStep step;
  final PageController controller;
  final int pageIndex;
  final double topAreaHeight;
  final bool showLanguagePicker;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        SizedBox(
          height: topAreaHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
            child: Column(
              children: [
                if (!showLanguagePicker) const Spacer(),

                // Titre / sous-titre (léger suivi pendant le swipe)
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    final page = controller.hasClients
                        ? (controller.page ?? controller.initialPage.toDouble())
                        : controller.initialPage.toDouble();
                    final delta = (page - pageIndex).clamp(-1.0, 1.0);
                    final t = 1.0 - delta.abs();
                    final eased = Curves.easeOutCubic.transform(t);
                    final titleSize = 28.sp; // page 1 alignée avec 2/3

                    return Opacity(
                      opacity: (0.25 + 0.75 * eased).clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(-delta * 18.w, (1 - eased) * 6.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              step.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.12,
                                    fontSize: titleSize,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            if (step.subtitle != null) ...[
                              SizedBox(height: 10.h),
                              Text(
                                step.subtitle!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.w500,
                                      height: 1.25,
                                      fontSize: 15.sp,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),

                if (showLanguagePicker) ...[
                  // Place les chips au milieu entre le titre et l'art
                  Expanded(
                    child: Align(
                      alignment: const Alignment(0, 0.2),
                      child: _LanguagePicker(
                        current: AppLocaleController.locale.value.languageCode,
                        onSelect: (code) =>
                            AppLocaleController.setLocale(Locale(code)),
                        hebrewLabel: l10n.languageHebrew,
                        frenchLabel: l10n.languageFrench,
                        englishLabel: l10n.languageEnglish,
                        russianLabel: l10n.languageRussian,
                        spanishLabel: l10n.languageSpanish,
                        amharicLabel: l10n.languageAmharic,
                      ),
                    ),
                  ),
                ] else ...[
                  const Spacer(),
                ],
              ],
            ),
          ),
        ),
        // Zone "art" (image + bulles) en dessous
        const Expanded(child: SizedBox.shrink()),
      ],
    );
  }
}

/// Un seul set de bulles + une seule carte image qui suit le swipe.
/// Objectif: créer un "lien" entre les pages (mêmes bulles, qui se déplacent).
class _PersistentOnboardingArt extends StatelessWidget {
  const _PersistentOnboardingArt({
    required this.controller,
    required this.imagePaths,
  });

  final PageController controller;
  final List<String> imagePaths;

  BorderRadius _imageRadius() => BorderRadius.only(
        topLeft: Radius.circular(140.r),
        topRight: Radius.circular(140.r),
        bottomLeft: Radius.circular(100.r),
        bottomRight: Radius.circular(140.r),
      );

  Offset _lerpOffset(Offset a, Offset b, double t) =>
      Offset(ui.lerpDouble(a.dx, b.dx, t)!, ui.lerpDouble(a.dy, b.dy, t)!);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final page = controller.hasClients
              ? (controller.page ?? controller.initialPage.toDouble())
              : controller.initialPage.toDouble();

          final baseIndex = page.floor().clamp(0, imagePaths.length - 1);
          final nextIndex = (baseIndex + 1).clamp(0, imagePaths.length - 1);
          final localT = (page - baseIndex).clamp(0.0, 1.0);
          final easedT = Curves.easeInOutCubic.transform(localT);

          // Keyframes (positions des mêmes bulles selon la page)
          // On garde le design (mêmes tailles / alphas), on anime uniquement les placements.
          final bubbleLeft = [
            Offset(-150.w, -40.h),
            Offset(-120.w, -60.h),
            // Page 3: position distincte (ne revient pas comme page 1)
            Offset(-175.w, 8.h),
          ];
          final bubbleRight = [
            Offset(150.w, -60.h),
            Offset(170.w, -30.h),
            // Page 3: plus haut et plus à droite
            Offset(185.w, -88.h),
          ];
          final bubbleBottomRight = [
            Offset(80.w, 90.h),
            Offset(110.w, 70.h),
            // Page 3: plus bas et plus vers l'intérieur
            Offset(35.w, 125.h),
          ];

          Offset kf(List<Offset> frames) =>
              _lerpOffset(frames[baseIndex], frames[nextIndex], easedT);

          final leftPos = kf(bubbleLeft);
          final rightPos = kf(bubbleRight);
          final bottomRightPos = kf(bubbleBottomRight);

          // Micro mouvement global de la carte pendant le swipe (sans couper le contenu)
          final globalDx = (-(page - baseIndex - localT) * 10.w);

          return Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Transform.translate(
                  offset: leftPos,
                  child: Container(
                    width: 80.r,
                    height: 80.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: rightPos,
                  child: Container(
                    width: 100.r,
                    height: 100.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: bottomRightPos,
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(globalDx, 0),
                  child: Container(
                    width: 280.r,
                    height: 280.r,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: _imageRadius(),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 22.r,
                          offset: Offset(0, 12.h),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: _imageRadius(),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          for (int i = 0; i < imagePaths.length; i++)
                            _OnboardingImageLayer(
                              imagePath: imagePaths[i],
                              page: page,
                              index: i,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OnboardingImageLayer extends StatelessWidget {
  const _OnboardingImageLayer({
    required this.imagePath,
    required this.page,
    required this.index,
  });

  final String imagePath;
  final double page;
  final int index;

  @override
  Widget build(BuildContext context) {
    final d = (page - index).abs().clamp(0.0, 1.0);
    final raw = (1.0 - d).clamp(0.0, 1.0);
    final opacity = Curves.easeOutCubic.transform(raw);
    final dx = (index - page) * 22.w;
    final scale = 0.98 + 0.02 * opacity;

    if (opacity <= 0.001) return const SizedBox.shrink();

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(dx, 0),
        child: Transform.scale(
          scale: scale,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({
    required this.current,
    required this.onSelect,
    required this.hebrewLabel,
    required this.frenchLabel,
    required this.englishLabel,
    required this.russianLabel,
    required this.spanishLabel,
    required this.amharicLabel,
  });

  final String current;
  final ValueChanged<String> onSelect;
  final String hebrewLabel;
  final String frenchLabel;
  final String englishLabel;
  final String russianLabel;
  final String spanishLabel;
  final String amharicLabel;

  @override
  Widget build(BuildContext context) {
    Widget flagForLanguage(String languageCode) {
      // Mapping langue -> pays (ISO-3166) pour afficher un drapeau.
      // Note: c’est un choix UX (anglais -> US).
      final countryCode = switch (languageCode) {
        'he' => 'IL',
        'fr' => 'FR',
        'en' => 'US',
        'ru' => 'RU',
        'es' => 'ES',
        'am' => 'ET',
        _ => 'UN',
      };

      return CountryFlag.fromCountryCode(
        countryCode,
        theme: ImageTheme(
          width: 16.w,
          height: 11.h,
          shape: RoundedRectangle(2.r),
        ),
      );
    }

    Widget chip({required String code, required String label}) {
      final isSelected = current == code;
      return ChoiceChip(
        avatar: flagForLanguage(code),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onSelect(code),
        showCheckmark: false,
        selectedColor: Colors.white.withValues(alpha: 0.95),
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        side: BorderSide(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
          width: isSelected ? 1.5.w : 1.w,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
      );
    }

    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      alignment: WrapAlignment.center,
      children: [
        chip(code: 'he', label: hebrewLabel),
        chip(code: 'fr', label: frenchLabel),
        chip(code: 'en', label: englishLabel),
        chip(code: 'ru', label: russianLabel),
        chip(code: 'es', label: spanishLabel),
        chip(code: 'am', label: amharicLabel),
      ],
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.title,
    required this.imagePath,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final String imagePath;
}
