import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../l10n/l10n.dart';

class AppointmentInstructionsPage extends StatefulWidget {
  const AppointmentInstructionsPage({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  State<AppointmentInstructionsPage> createState() =>
      _AppointmentInstructionsPageState();
}

class _AppointmentInstructionsPageState
    extends State<AppointmentInstructionsPage> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DokalAppBar(
        title: l10n.appointmentDetailPrepInstructions,
        subtitle: l10n.appointmentPrepInstructionsSubtitle,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.lg.r),
          children: [
            DokalCard(
              padding: EdgeInsets.all(AppSpacing.md.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bullet(text: l10n.appointmentPrepInstruction1),
                  SizedBox(height: AppSpacing.sm.h),
                  _Bullet(text: l10n.appointmentPrepInstruction2),
                  SizedBox(height: AppSpacing.sm.h),
                  _Bullet(text: l10n.appointmentPrepInstruction3),
                  SizedBox(height: AppSpacing.md.h),
                  CheckboxListTile(
                    value: _accepted,
                    onChanged: (v) => setState(() => _accepted = v ?? false),
                    title: Text(l10n.appointmentPrepInstructionsAccept),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            DokalButton.primary(
              onPressed: !_accepted
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.appointmentPrepSavedSnack)),
                      );
                      if (context.canPop()) context.pop();
                    },
              leading: const Icon(Icons.check_rounded),
              child: Text(l10n.commonContinue),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6.r,
          height: 6.r,
          margin: EdgeInsets.only(top: 7.h),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.35),
          ),
        ),
      ],
    );
  }
}
