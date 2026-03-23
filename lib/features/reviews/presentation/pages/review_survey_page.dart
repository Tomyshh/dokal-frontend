import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_animations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_fade_in.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/reviews_cubit.dart';
import '../bloc/reviews_state.dart';

class ReviewSurveyPage extends StatefulWidget {
  const ReviewSurveyPage({
    super.key,
    required this.appointmentId,
    required this.practitionerId,
    this.prefilledRating,
  });

  final String appointmentId;
  final String practitionerId;
  final int? prefilledRating;

  @override
  State<ReviewSurveyPage> createState() => _ReviewSurveyPageState();
}

class _ReviewSurveyPageState extends State<ReviewSurveyPage> {
  int _rating = 0;
  String? _waitTime;
  final _commentCtrl = TextEditingController();
  bool _isAnonymous = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledRating != null &&
        widget.prefilledRating! >= 1 &&
        widget.prefilledRating! <= 5) {
      _rating = widget.prefilledRating!;
    }
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_rating == 0) return;
    context.read<ReviewsCubit>().submit(
          appointmentId: widget.appointmentId,
          practitionerId: widget.practitionerId,
          rating: _rating,
          comment: _commentCtrl.text.trim().isEmpty
              ? null
              : _commentCtrl.text.trim(),
          waitTime: _waitTime,
          isAnonymous: _isAnonymous,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => sl<ReviewsCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: DokalAppBar(
          title: l10n.reviewSurveyTitle,
          centerTitle: true,
        ),
        body: BlocConsumer<ReviewsCubit, ReviewsState>(
          listener: (context, state) {
            if (state.status == ReviewsStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.reviewSuccessMessage)),
              );
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            }
            if (state.status == ReviewsStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? l10n.commonError)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.status == ReviewsStatus.loading;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg.w,
                AppSpacing.lg.h,
                AppSpacing.lg.w,
                AppSpacing.lg.h + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Stars ─────────────────────────────────────
                  DokalFadeIn(
                    child: _RatingSection(
                      rating: _rating,
                      onChanged: (r) => setState(() => _rating = r),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl.h),

                  // ── Wait time ─────────────────────────────────
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(1),
                    child: _WaitTimeSection(
                      selected: _waitTime,
                      onChanged: (v) => setState(() => _waitTime = v),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl.h),

                  // ── Comment ───────────────────────────────────
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(2),
                    child: _CommentSection(controller: _commentCtrl),
                  ),
                  SizedBox(height: AppSpacing.xl.h),

                  // ── Anonymous toggle ──────────────────────────
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(3),
                    child: _AnonymousToggle(
                      value: _isAnonymous,
                      onChanged: (v) => setState(() => _isAnonymous = v),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl.h),

                  // ── Submit ────────────────────────────────────
                  DokalFadeIn(
                    delay: AppAnimations.staggerDelayFor(4),
                    child: DokalButton.primary(
                      onPressed: _rating == 0 || isLoading
                          ? null
                          : () => _submit(context),
                      isLoading: isLoading,
                      child: Text(l10n.reviewSubmitButton),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// RATING STARS
// ═══════════════════════════════════════════════════════════════════════════════

class _RatingSection extends StatelessWidget {
  const _RatingSection({required this.rating, required this.onChanged});

  final int rating;
  final ValueChanged<int> onChanged;

  String _label(BuildContext context) {
    final l10n = context.l10n;
    return switch (rating) {
      1 => l10n.reviewRating1,
      2 => l10n.reviewRating2,
      3 => l10n.reviewRating3,
      4 => l10n.reviewRating4,
      5 => l10n.reviewRating5,
      _ => l10n.reviewRatingPrompt,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.xxl.r),
        boxShadow: AppShadows.sm,
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Column(
        children: [
          Text(
            l10n.reviewOverallRating,
            style: AppTextStyles.titleLg(),
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final star = i + 1;
              final isSelected = star <= rating;
              return GestureDetector(
                onTap: () => onChanged(star),
                child: AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: AppAnimations.fast,
                  curve: AppAnimations.bounce,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Icon(
                      isSelected
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 44.sp,
                      color: isSelected
                          ? const Color(0xFFF59E0B)
                          : AppColors.outline,
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: AppSpacing.md.h),
          AnimatedSwitcher(
            duration: AppAnimations.fast,
            child: Text(
              _label(context),
              key: ValueKey(rating),
              style: AppTextStyles.labelMd(
                color: rating > 0
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// WAIT TIME
// ═══════════════════════════════════════════════════════════════════════════════

class _WaitTimeSection extends StatelessWidget {
  const _WaitTimeSection({required this.selected, required this.onChanged});

  final String? selected;
  final ValueChanged<String?> onChanged;

  static const _options = [
    'under_15',
    '15_30',
    '30_45',
    '45_60',
    'over_60',
  ];

  String _label(String key, BuildContext context) {
    final l10n = context.l10n;
    return switch (key) {
      'under_15' => l10n.reviewWaitUnder15,
      '15_30' => l10n.reviewWait1530,
      '30_45' => l10n.reviewWait3045,
      '45_60' => l10n.reviewWait4560,
      'over_60' => l10n.reviewWaitOver60,
      _ => key,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.reviewWaitTimeTitle, style: AppTextStyles.titleLg()),
        SizedBox(height: AppSpacing.sm.h),
        Text(l10n.reviewWaitTimeSubtitle, style: AppTextStyles.bodySm()),
        SizedBox(height: AppSpacing.md.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: _options.map((key) {
            final isSelected = selected == key;
            return GestureDetector(
              onTap: () => onChanged(isSelected ? null : key),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primarySurface
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.pill.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.outline,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  _label(key, context),
                  style: AppTextStyles.labelSm(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMMENT
// ═══════════════════════════════════════════════════════════════════════════════

class _CommentSection extends StatelessWidget {
  const _CommentSection({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.reviewCommentTitle, style: AppTextStyles.titleLg()),
        SizedBox(height: AppSpacing.sm.h),
        Text(l10n.reviewCommentOptional, style: AppTextStyles.bodySm()),
        SizedBox(height: AppSpacing.md.h),
        TextField(
          controller: controller,
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: l10n.reviewCommentHint,
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.xl.r),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ANONYMOUS TOGGLE
// ═══════════════════════════════════════════════════════════════════════════════

class _AnonymousToggle extends StatelessWidget {
  const _AnonymousToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.xl.r),
        border: Border.all(color: AppColors.outlineSoft),
        boxShadow: AppShadows.xs,
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadii.lg.r),
            ),
            child: Icon(
              Icons.visibility_off_rounded,
              size: 20.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.reviewAnonymousTitle,
                    style: AppTextStyles.titleSm()),
                SizedBox(height: 2.h),
                Text(
                  l10n.reviewAnonymousSubtitle,
                  style: AppTextStyles.bodyXs(),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
