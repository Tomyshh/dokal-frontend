import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
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
        imagePath: 'assets/images/onboarding_2.jpeg',
      ),
      _OnboardingStep(
        title: l10n.onboardingStep3Title,
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
          backgroundColor: const Color(0xFFE8F4F8), // Fond bleu très clair
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
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      final step = pages[index];
                      return _OnboardingContent(
                        step: step,
                        showLanguagePicker: index == 0,
                      );
                    },
                  ),
                ),
                // Bouton en bas
                Padding(
                  padding: EdgeInsets.all(AppSpacing.xl.r),
                  child: BlocBuilder<OnboardingCubit, OnboardingState>(
                    builder: (context, state) {
                      final isLoading =
                          state.status == OnboardingStatus.loading;
                      return DokalButton.primary(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (!isLast) {
                                  _nextPage();
                                  return;
                                }
                                context.read<OnboardingCubit>().complete();
                              },
                        isLoading: isLoading,
                        child: Text(
                          isLast
                              ? l10n.onboardingStartButton
                              : l10n.onboardingContinueButton,
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
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.2),
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
    return Image.asset(
      'assets/branding/icononly_transparent_nobuffer.png',
      height: 56.h,
      fit: BoxFit.contain,
      color: const Color(0xFF005044),
    );
  }
}

/// Contenu d'une étape d'onboarding
class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({
    required this.step,
    this.showLanguagePicker = false,
  });

  final _OnboardingStep step;
  final bool showLanguagePicker;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        if (showLanguagePicker) ...[
          SizedBox(height: AppSpacing.md.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
            child: _LanguagePicker(
              current: AppLocaleController.locale.value.languageCode,
              onSelect: (code) => AppLocaleController.setLocale(Locale(code)),
              hebrewLabel: l10n.languageHebrew,
              frenchLabel: l10n.languageFrench,
              englishLabel: l10n.languageEnglish,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
        ],
        // Titre
        Text(
          step.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.xxxl.h),
        // Image avec formes décoratives
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
            child: _ImagePlaceholder(imagePath: step.imagePath),
          ),
        ),
      ],
    );
  }
}

/// Placeholder pour l'image avec formes décoratives
class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Forme décorative gauche
        Positioned(
          left: 0,
          top: 40.h,
          child: Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(40.r),
            ),
          ),
        ),
        // Forme décorative droite
        Positioned(
          right: 0,
          top: 20.h,
          child: Container(
            width: 100.r,
            height: 100.r,
            decoration: BoxDecoration(
              color: const Color(0xFF00D4FF).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
        ),
        // Forme décorative bas droite
        Positioned(
          right: 40.w,
          bottom: 60.h,
          child: Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              color: const Color(0xFF00D4FF).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
        ),
        // Container principal de l'image
        Container(
          width: 280.r,
          height: 280.r,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(140.r),
              topRight: Radius.circular(140.r),
              bottomLeft: Radius.circular(100.r),
              bottomRight: Radius.circular(140.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(140.r),
              topRight: Radius.circular(140.r),
              bottomLeft: Radius.circular(100.r),
              bottomRight: Radius.circular(140.r),
            ),
            child: Image.asset(
              imagePath,
              width: 280.r,
              height: 280.r,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
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
  });

  final String current;
  final ValueChanged<String> onSelect;
  final String hebrewLabel;
  final String frenchLabel;
  final String englishLabel;

  @override
  Widget build(BuildContext context) {
    Widget chip({required String code, required String label}) {
      return ChoiceChip(
        label: Text(label),
        selected: current == code,
        onSelected: (_) => onSelect(code),
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        side: BorderSide(
          color: current == code ? AppColors.primary : AppColors.outline,
        ),
        labelStyle: TextStyle(
          color: current == code ? AppColors.primary : AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      alignment: WrapAlignment.center,
      children: [
        chip(code: 'he', label: hebrewLabel),
        chip(code: 'fr', label: frenchLabel),
        chip(code: 'en', label: englishLabel),
      ],
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({required this.title, required this.imagePath});

  final String title;
  final String imagePath;
}
