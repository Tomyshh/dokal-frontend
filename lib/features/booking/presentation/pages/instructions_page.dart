import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/booking_bloc.dart';

class InstructionsPage extends StatefulWidget {
  const InstructionsPage({super.key});

  @override
  State<InstructionsPage> createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final practitionerId = context.read<BookingBloc>().state.practitionerId;

    return ListView(
      padding: EdgeInsets.all(AppSpacing.xl.r),
      children: [
        Text(
          l10n.bookingInstructionsTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          l10n.bookingInstructionsSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: AppSpacing.xl.h),
        DokalCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Bullet(l10n.bookingInstructionsBullet1),
              SizedBox(height: 10.h),
              _Bullet(l10n.bookingInstructionsBullet2),
              SizedBox(height: 10.h),
              _Bullet(l10n.bookingInstructionsBullet3),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.lg.h),
        DokalCard(
          child: Row(
            children: [
              Checkbox(
                value: _accepted,
                onChanged: (v) => setState(() => _accepted = v ?? false),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  l10n.bookingInstructionsAccept,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.lg.h),
        DokalButton.primary(
          onPressed: !_accepted
              ? null
              : () {
                  context.read<BookingBloc>().add(
                    const BookingInstructionsAccepted(),
                  );
                  context.go('/booking/$practitionerId/slot');
                },
          child: Text(l10n.commonContinue),
        ),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: Icon(Icons.check_rounded, size: 18.sp),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
