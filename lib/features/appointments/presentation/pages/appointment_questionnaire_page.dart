import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_locale_controller.dart';
import '../../../../l10n/l10n.dart';
import '../../data/datasources/appointments_remote_data_source.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/questionnaire_field.dart';

class AppointmentQuestionnairePage extends StatefulWidget {
  const AppointmentQuestionnairePage({
    super.key,
    required this.appointmentId,
    required this.appointment,
  });

  final String appointmentId;
  final Appointment appointment;

  @override
  State<AppointmentQuestionnairePage> createState() =>
      _AppointmentQuestionnairePageState();
}

class _AppointmentQuestionnairePageState
    extends State<AppointmentQuestionnairePage> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;

  bool _consent = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final field in widget.appointment.questionnaireFields)
        field.id: TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = context.l10n;
    if (!_consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.appointmentPrepConsentRequired)),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final answers = {
        for (final field in widget.appointment.questionnaireFields)
          field.id: _controllers[field.id]!.text.trim(),
      };
      await sl<AppointmentsRemoteDataSourceImpl>().submitQuestionnaireAsync(
        widget.appointmentId,
        answers: answers,
        consent: true,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.appointmentPrepSavedSnack)),
      );
      if (context.canPop()) context.pop(true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.appointmentPrepSubmitError)),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final fields = widget.appointment.questionnaireFields;
    final alreadySubmitted = widget.appointment.questionnaireSubmitted;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DokalAppBar(
        title: l10n.appointmentDetailPrepQuestionnaire,
        subtitle: l10n.appointmentPrepQuestionnaireSubtitle,
      ),
      body: SafeArea(
        child: fields.isEmpty
            ? _EmptyQuestionnaire()
            : alreadySubmitted
                ? _AlreadySubmittedState()
                : ListView(
                    padding: EdgeInsets.all(AppSpacing.lg.r),
                    children: [
                      DokalCard(
                        padding: EdgeInsets.all(AppSpacing.md.r),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...fields.asMap().entries.map((entry) {
                                final field = entry.value;
                                return Column(
                                  children: [
                                    _DynamicTextField(
                                      field: field,
                                      controller: _controllers[field.id]!,
                                    ),
                                    if (entry.key < fields.length - 1)
                                      SizedBox(height: AppSpacing.md.h),
                                  ],
                                );
                              }),
                              SizedBox(height: AppSpacing.md.h),
                              SwitchListTile.adaptive(
                                value: _consent,
                                onChanged: (v) =>
                                    setState(() => _consent = v),
                                title: Text(l10n.appointmentPrepConsentLabel),
                                activeThumbColor: AppColors.primary,
                                activeTrackColor: AppColors.primary.withValues(
                                  alpha: 0.35,
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      DokalButton.primary(
                        onPressed: _submitting ? null : _submit,
                        leading: _submitting
                            ? SizedBox(
                                width: 18.r,
                                height: 18.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check_rounded),
                        child: Text(
                          _submitting
                              ? l10n.appointmentPrepSubmitting
                              : l10n.appointmentPrepSubmit,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state – practitioner hasn't set up a questionnaire
// ---------------------------------------------------------------------------

class _EmptyQuestionnaire extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 48.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              l10n.appointmentPrepNoQuestionnaire,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Already submitted state
// ---------------------------------------------------------------------------

class _AlreadySubmittedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 48.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              l10n.appointmentPrepSavedSnack,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dynamic text field rendered from QuestionnaireField
// ---------------------------------------------------------------------------

class _DynamicTextField extends StatelessWidget {
  const _DynamicTextField({
    required this.field,
    required this.controller,
  });

  final QuestionnaireField field;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = AppLocaleController.locale.value.languageCode;
    final localizedLabel = field.localizedLabel(locale);
    return TextFormField(
      controller: controller,
      maxLines: field.maxLines,
      decoration: InputDecoration(
        labelText: field.isRequired
              ? localizedLabel
              : '$localizedLabel (${l10n.addRelativeKupatOptional.toLowerCase()})',
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      validator: (v) {
        if (!field.isRequired) return null;
        final t = (v ?? '').trim();
        if (t.isEmpty) return l10n.commonRequired;
        return null;
      },
    );
  }
}
