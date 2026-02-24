import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_chip.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/booking_bloc.dart';

class SelectReasonPage extends StatelessWidget {
  const SelectReasonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final practitionerId = context.read<BookingBloc>().state.practitionerId;
    final reasons = [
      l10n.bookingReasonNewPatient,
      l10n.bookingReasonFollowUp,
      l10n.bookingReasonUrgency,
      l10n.bookingReasonPrescription,
      l10n.bookingReasonResults,
    ];

    return ListView(
      padding: EdgeInsets.all(AppSpacing.xl.r),
      children: [
        Text(
          l10n.bookingSelectReasonTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          l10n.bookingSelectReasonSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: AppSpacing.xl.h),
        BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            return Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                for (final r in reasons)
                  DokalChip(
                    label: r,
                    icon: Icons.medical_information_rounded,
                    selected: state.reason == r,
                    onTap: () {
                      context.read<BookingBloc>().add(BookingReasonSelected(r));
                      context.go('/booking/$practitionerId/patient');
                    },
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
