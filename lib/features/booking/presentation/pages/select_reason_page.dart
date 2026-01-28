import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_chip.dart';
import '../bloc/booking_bloc.dart';

class SelectReasonPage extends StatelessWidget {
  const SelectReasonPage({super.key});

  static const _reasons = <String>[
    'Consultation (nouveau patient)',
    'Suivi / contrôle',
    'Urgence (douleur, gêne)',
    'Renouvellement ordonnance',
    'Résultats / compte-rendu',
  ];

  @override
  Widget build(BuildContext context) {
    final practitionerId = context.read<BookingBloc>().state.practitionerId;

    return ListView(
      padding: EdgeInsets.all(AppSpacing.xl.r),
      children: [
        Text(
          'Choisir un motif',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          'Sélectionnez le motif du rendez-vous pour personnaliser les créneaux et les instructions.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: AppSpacing.xl.h),
        BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            return Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                for (final r in _reasons)
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
