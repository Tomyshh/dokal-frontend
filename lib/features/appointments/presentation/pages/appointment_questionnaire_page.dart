import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../l10n/l10n.dart';

class AppointmentQuestionnairePage extends StatefulWidget {
  const AppointmentQuestionnairePage({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  State<AppointmentQuestionnairePage> createState() =>
      _AppointmentQuestionnairePageState();
}

class _AppointmentQuestionnairePageState
    extends State<AppointmentQuestionnairePage> {
  final _formKey = GlobalKey<FormState>();

  final _symptoms = TextEditingController();
  final _allergies = TextEditingController();
  final _medications = TextEditingController();
  final _other = TextEditingController();

  bool _consent = false;

  @override
  void dispose() {
    _symptoms.dispose();
    _allergies.dispose();
    _medications.dispose();
    _other.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DokalAppBar(
        title: l10n.appointmentDetailPrepQuestionnaire,
        subtitle: l10n.appointmentPrepQuestionnaireSubtitle,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.lg.r),
          children: [
            DokalCard(
              padding: EdgeInsets.all(AppSpacing.md.r),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _QuestionTextField(
                      label: l10n.appointmentPrepQuestionSymptoms,
                      controller: _symptoms,
                      minChars: 5,
                      maxLines: 3,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    _QuestionTextField(
                      label: l10n.appointmentPrepQuestionAllergies,
                      controller: _allergies,
                      minChars: 0,
                      maxLines: 2,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    _QuestionTextField(
                      label: l10n.appointmentPrepQuestionMedications,
                      controller: _medications,
                      minChars: 0,
                      maxLines: 2,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    _QuestionTextField(
                      label: l10n.appointmentPrepQuestionOther,
                      controller: _other,
                      minChars: 0,
                      maxLines: 3,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    SwitchListTile.adaptive(
                      value: _consent,
                      onChanged: (v) => setState(() => _consent = v),
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
              onPressed: () {
                if (!(_formKey.currentState?.validate() ?? false)) return;
                if (!_consent) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.appointmentPrepConsentRequired),
                    ),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.appointmentPrepSavedSnack)),
                );
                if (context.canPop()) context.pop();
              },
              leading: const Icon(Icons.check_rounded),
              child: Text(l10n.appointmentPrepSubmit),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionTextField extends StatelessWidget {
  const _QuestionTextField({
    required this.label,
    required this.controller,
    required this.minChars,
    required this.maxLines,
  });

  final String label;
  final TextEditingController controller;
  final int minChars;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      validator: (v) {
        final t = (v ?? '').trim();
        if (minChars <= 0) return null;
        if (t.length < minChars) return l10n.commonMinChars(minChars);
        return null;
      },
    );
  }
}
