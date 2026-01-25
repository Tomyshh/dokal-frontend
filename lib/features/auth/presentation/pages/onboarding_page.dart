import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../injection_container.dart';
import '../bloc/onboarding_cubit.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingStep(
      title: 'Réservez facilement vos rendez-vous',
      imagePath: 'assets/images/onboarding_1.jpeg',
    ),
    _OnboardingStep(
      title: 'Échangez facilement avec vos praticiens',
      imagePath: 'assets/images/onboarding_2.jpeg',
    ),
    _OnboardingStep(
      title: 'Accédez à vos dossiers médicaux à tout moment',
      imagePath: 'assets/images/onboarding_3.jpeg',
    ),
  ];

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
    final isLast = _currentPage == _pages.length - 1;

    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state.status == OnboardingStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Erreur')),
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
                const SizedBox(height: AppSpacing.lg),
                // Barre de progression segmentée
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: _ProgressBar(
                    totalSteps: _pages.length,
                    currentStep: _currentPage,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                // Logo Dokal
                const _DokalLogo(),
                const SizedBox(height: AppSpacing.lg),
                // Contenu scrollable
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      final step = _pages[index];
                      return _OnboardingContent(step: step);
                    },
                  ),
                ),
                // Bouton en bas
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: BlocBuilder<OnboardingCubit, OnboardingState>(
                    builder: (context, state) {
                      final isLoading = state.status == OnboardingStatus.loading;
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
                        child: Text(isLast ? 'Commencer' : 'Continuer'),
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
  const _ProgressBar({
    required this.totalSteps,
    required this.currentStep,
  });

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
            height: 4,
            margin: EdgeInsets.only(
              left: isFirst ? 0 : 4,
              right: isLast ? 0 : 4,
            ),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
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
      height: 56,
      fit: BoxFit.contain,color: Color(0xFF005044),
    );
  }
}

/// Contenu d'une étape d'onboarding
class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({required this.step});

  final _OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Titre
        Text(
          step.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        // Image avec formes décoratives
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
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
          top: 40,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        // Forme décorative droite
        Positioned(
          right: 0,
          top: 20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF00D4FF).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        // Forme décorative bas droite
        Positioned(
          right: 40,
          bottom: 60,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF00D4FF).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        // Container principal de l'image
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(140),
              topRight: Radius.circular(140),
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(140),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(140),
              topRight: Radius.circular(140),
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(140),
            ),
            child: Image.asset(
              imagePath,
              width: 280,
              height: 280,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.title,
    required this.imagePath,
  });

  final String title;
  final String imagePath;
}
