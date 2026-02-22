import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_confirm_cubit.dart';

class ConfirmBookingPage extends StatelessWidget {
  const ConfirmBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final practitionerId = context.read<BookingBloc>().state.practitionerId;

    return BlocProvider(
      create: (_) => sl<BookingConfirmCubit>(),
      child: BlocConsumer<BookingConfirmCubit, BookingConfirmState>(
        listener: (context, state) {
          if (state.status == BookingConfirmStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? l10n.commonError)),
            );
          }
          if (state.status == BookingConfirmStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.bookingSuccessTitle),
                backgroundColor: AppColors.accent,
              ),
            );
            context.go('/booking/$practitionerId/success');
          }
        },
        builder: (context, confirmState) {
          final isLoading = confirmState.status == BookingConfirmStatus.loading;
          return ListView(
            padding: EdgeInsets.all(AppSpacing.xl.r),
            children: [
              Text(
                l10n.bookingConfirmTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),
              Text(
                l10n.bookingConfirmSubtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: AppSpacing.xl.h),
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      DokalCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Row(
                              icon: Icons.medical_information_rounded,
                              title: l10n.bookingReasonLabel,
                              value: state.reason ?? '—',
                            ),
                            SizedBox(height: 12.h),
                            _Row(
                              icon: Icons.person_rounded,
                              title: l10n.bookingPatientLabel,
                              value: state.patientLabel ?? '—',
                            ),
                            SizedBox(height: 12.h),
                            _Row(
                              icon: Icons.schedule_rounded,
                              title: l10n.bookingSlotLabel,
                              value: state.slotLabel ?? '—',
                            ),
                            SizedBox(height: 12.h),
                            _Row(
                              icon: Icons.location_on_rounded,
                              title: l10n.commonAddress,
                              value: '83 Boulevard de la Villette, 75010 Paris',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      DokalCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.bookingMissingInfoTitle,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: AppSpacing.md.h),
                            _InlineField(
                              label: l10n.commonAddress,
                              value: state.addressLine ?? '',
                              onChanged: (v) => context.read<BookingBloc>().add(
                                BookingAddressChanged(v),
                              ),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                            _InlineField(
                              label: l10n.bookingZipCodeLabel,
                              value: state.zipCode ?? '',
                              keyboardType: TextInputType.number,
                              onChanged: (v) => context.read<BookingBloc>().add(
                                BookingZipCodeChanged(v),
                              ),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                            _InlineField(
                              label: l10n.commonCity,
                              value: state.city ?? '',
                              onChanged: (v) => context.read<BookingBloc>().add(
                                BookingCityChanged(v),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      DokalCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.bookingVisitedBeforeQuestion,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                            Row(
                              children: [
                                Expanded(
                                  child: _YesNoButton(
                                    label: l10n.commonYes,
                                    selected: state.visitedBefore == true,
                                    onTap: () =>
                                        context.read<BookingBloc>().add(
                                          const BookingVisitedBeforeChanged(
                                            true,
                                          ),
                                        ),
                                  ),
                                ),
                                SizedBox(width: AppSpacing.md.w),
                                Expanded(
                                  child: _YesNoButton(
                                    label: l10n.commonNo,
                                    selected: state.visitedBefore == false,
                                    onTap: () =>
                                        context.read<BookingBloc>().add(
                                          const BookingVisitedBeforeChanged(
                                            false,
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      if (isLoading) ...[
                        const DokalLoader(lines: 2),
                        SizedBox(height: AppSpacing.lg.h),
                      ],
                      DokalButton.primary(
                        onPressed: (!state.isReadyToConfirm || isLoading)
                            ? null
                            : () => context.read<BookingConfirmCubit>().confirm(
                                practitionerId: practitionerId,
                                reason: state.reason!,
                                patientLabel: state.patientLabel!,
                                slotLabel: state.slotLabel!,
                                addressLine: state.addressLine!.trim(),
                                zipCode: state.zipCode!.trim(),
                                city: state.city!.trim(),
                                visitedBefore: state.visitedBefore!,
                              ),
                        leading: const Icon(Icons.check_rounded),
                        child: Text(l10n.bookingConfirmButton),
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      DokalButton.outline(
                        onPressed: isLoading
                            ? null
                            : () => context.go('/booking/$practitionerId/slot'),
                        child: Text(l10n.bookingChangeSlotButton),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Icon(icon, size: 18.sp),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              SizedBox(height: 4.h),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _InlineField extends StatefulWidget {
  const _InlineField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.keyboardType,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  State<_InlineField> createState() => _InlineFieldState();
}

class _InlineFieldState extends State<_InlineField> {
  late final TextEditingController _c = TextEditingController(
    text: widget.value,
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ok = _c.text.trim().isNotEmpty;
    return TextField(
      controller: _c,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: ok
            ? Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
      ),
      onChanged: (v) {
        setState(() {});
        widget.onChanged(v);
      },
    );
  }
}

class _YesNoButton extends StatelessWidget {
  const _YesNoButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
        : Colors.white;
    final border = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).dividerColor;
    final fg = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: border, width: 1.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: fg,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
