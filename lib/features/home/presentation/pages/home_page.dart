import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../injection_container.dart';
import '../bloc/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // Header avec gradient bleu - sticky au top
            const _StickyHeader(),
            // Contenu
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppSpacing.md),
                  // Carousel de conseils santé
                  _HealthTipsCarousel(),
                  const SizedBox(height: AppSpacing.md),
                  // Card profil santé
                  _HealthProfileCard(),
                  const SizedBox(height: AppSpacing.lg),
                  // Section Mes praticiens
                  const _SectionTitle(title: 'Mes praticiens'),
                  const SizedBox(height: AppSpacing.xs),
                  _EmptyPractitionerCard(),
                  const SizedBox(height: AppSpacing.lg),
                  // Section Historique
                  const _SectionTitle(title: 'Historique'),
                  const SizedBox(height: AppSpacing.xs),
                  const _ActivateHistoryCard(),
                  const SizedBox(height: 100), // Espace pour la navbar
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Header sticky utilisant SliverAppBar
class _StickyHeader extends StatelessWidget {
  const _StickyHeader();

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 140,
      collapsedHeight: 140,
      toolbarHeight: 140,
      backgroundColor: const Color(0xFF005044),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF005044),
              Color(0xFF003D33),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            statusBarHeight + AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Salutation
              BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (p, n) =>
                    p.greetingName != n.greetingName || p.status != n.status,
                builder: (context, state) {
                  final name = state.greetingName;
                  return Text(
                    'Bonjour $name',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // Barre de recherche moderne
              GestureDetector(
                onTap: () => context.go('/home/search'),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Praticien, spécialité...',
                          style: TextStyle(
                            color: AppColors.textSecondary.withValues(alpha: 0.7),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLightBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Carousel de conseils santé
class _HealthTipsCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _HealthTipCard(
            text: 'Cette année, adoptez les bons réflexes santé.',
            showImage: true,
          ),
          const SizedBox(width: AppSpacing.sm),
          _HealthTipCard(
            text: 'Il est encore temps de vous faire vacciner.',
            showArrow: true,
          ),
        ],
      ),
    );
  }
}

/// Card de conseil santé
class _HealthTipCard extends StatelessWidget {
  const _HealthTipCard({
    required this.text,
    this.showImage = false,
    this.showArrow = false,
  });

  final String text;
  final bool showImage;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.35,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showImage) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.people_rounded,
                size: 32,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
          ],
          if (showArrow) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.outline,
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Card profil santé - design compact
class _HealthProfileCard extends StatefulWidget {
  @override
  State<_HealthProfileCard> createState() => _HealthProfileCardState();
}

class _HealthProfileCardState extends State<_HealthProfileCard> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLightBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenu texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Compléter votre profil santé',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isVisible = false),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Recevez des rappels personnalisés et préparez vos RDV',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _CompactButton(
                  label: 'Commencer',
                  onTap: () => context.go('/health'),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Icône coeur
          _HeartPulseIcon(),
        ],
      ),
    );
  }
}

/// Bouton compact stylisé
class _CompactButton extends StatelessWidget {
  const _CompactButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Icône coeur avec pulse
class _HeartPulseIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.favorite,
            color: Colors.pinkAccent,
            size: 28,
          ),
          Positioned(
            right: 2,
            bottom: 6,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.show_chart,
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Titre de section
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }
}

/// Card praticien vide
class _EmptyPractitionerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLightBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Aucun praticien récent',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card activation historique
class _ActivateHistoryCard extends StatelessWidget {
  const _ActivateHistoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLightBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône horloge avec badge
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: Colors.pinkAccent,
                    size: 22,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.priority_high,
                      size: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vous pouvez afficher la liste des praticiens que vous avez consultés',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                BlocConsumer<HomeCubit, HomeState>(
                  listenWhen: (p, n) => p.historyEnabled != n.historyEnabled,
                  listener: (context, state) {
                    if (state.historyEnabled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Historique activé')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.historyEnabled) {
                      return Text(
                        'Historique activé',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () => context.read<HomeCubit>().activateHistory(),
                      child: Text(
                        'Activer l\'historique',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
