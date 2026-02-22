import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/booking_patients_cubit.dart';
import '../bloc/booking_bloc.dart';

class SelectPatientPage extends StatelessWidget {
  const SelectPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final practitionerId = context.read<BookingBloc>().state.practitionerId;

    return BlocProvider(
      create: (_) => sl<BookingPatientsCubit>(),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.bookingSelectPatientTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Expanded(
              child: BlocBuilder<BookingPatientsCubit, BookingPatientsState>(
                builder: (context, pState) {
                  if (pState.status == BookingPatientsStatus.loading) {
                    return const DokalLoader(lines: 5);
                  }
                  if (pState.status == BookingPatientsStatus.failure) {
                    return DokalEmptyState(
                      title: l10n.bookingPatientsUnavailableTitle,
                      subtitle: pState.error ?? l10n.commonTryAgainLater,
                      icon: Icons.person_off_rounded,
                    );
                  }

                  return BlocBuilder<BookingBloc, BookingState>(
                    builder: (context, bookingState) {
                      final meName = pState.me.fullName;
                      final initials = _initials(
                        meName,
                        fallback: l10n.commonInitialsFallback,
                      );

                      return DokalCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg.w,
                                vertical: AppSpacing.md.h,
                              ),
                              leading: CircleAvatar(
                                radius: 20.r,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.12),
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              title: Text(
                                '$meName (${l10n.commonMe})',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              trailing: bookingState.patientLabel == meName
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    )
                                  : const Icon(Icons.chevron_right_rounded),
                              onTap: () {
                                context.read<BookingBloc>().add(
                                  BookingPatientSelected(meName),
                                );
                                context.go(
                                  '/booking/$practitionerId/instructions',
                                );
                              },
                            ),
                            Divider(height: 1.h),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg.w,
                                vertical: AppSpacing.sm.h,
                              ),
                              leading: Icon(
                                Icons.add_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              title: Text(
                                l10n.bookingAddRelative,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              onTap: () async {
                                await context.push('/account/relatives/add');
                                if (context.mounted) {
                                  context.read<BookingPatientsCubit>().load();
                                }
                              },
                            ),
                            if (pState.relatives.isNotEmpty) ...[
                              Divider(height: 1.h),
                              for (final r in pState.relatives)
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg.w,
                                    vertical: AppSpacing.sm.h,
                                  ),
                                  leading: CircleAvatar(
                                    radius: 18.r,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.10),
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(r.name),
                                  subtitle: Text(r.label),
                                  trailing: bookingState.patientLabel == r.name
                                      ? Icon(
                                          Icons.check_circle_rounded,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        )
                                      : const Icon(Icons.chevron_right_rounded),
                                  onTap: () {
                                    context.read<BookingBloc>().add(
                                      BookingPatientSelected(r.name),
                                    );
                                    context.go(
                                      '/booking/$practitionerId/instructions',
                                    );
                                  },
                                ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _initials(String name, {required String fallback}) {
  final parts = name.trim().split(RegExp(r'\s+'));
  final letters = parts
      .take(2)
      .where((p) => p.isNotEmpty)
      .map((p) => p[0])
      .join();
  return letters.isEmpty ? fallback : letters.toUpperCase();
}
