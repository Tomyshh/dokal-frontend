import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/payment_method.dart';
import '../bloc/payment_cubit.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<PaymentCubit>(),
      child: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state.status == PaymentStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? l10n.commonError)),
            );
          }
        },
        builder: (context, state) {
          final List<PaymentMethod> items = state.items;
          return Scaffold(
            appBar: DokalAppBar(title: l10n.paymentTitle),
            body: state.status == PaymentStatus.loading
                ? Padding(
                    padding: EdgeInsets.all(AppSpacing.lg.r),
                    child: const DokalLoader(lines: 5),
                  )
                : items.isEmpty
                ? DokalEmptyState(
                    title: l10n.paymentEmptyTitle,
                    subtitle: l10n.paymentEmptySubtitle,
                    icon: Icons.payments_rounded,
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(AppSpacing.lg.r),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: AppSpacing.sm.h),
                    itemBuilder: (context, index) {
                      final pm = items[index];
                      return DokalCard(
                        padding: EdgeInsets.all(AppSpacing.md.r),
                        child: Row(
                          children: [
                            Container(
                              width: 36.r,
                              height: 36.r,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppRadii.sm.r,
                                ),
                              ),
                              child: Icon(
                                Icons.credit_card_rounded,
                                size: 18.sp,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: AppSpacing.md.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${pm.brandLabel} •••• ${pm.last4}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    l10n.paymentExpires(pm.expiry),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            floatingActionButton: FloatingActionButton.small(
              heroTag: 'fab_payment_methods',
              onPressed: () => context.read<PaymentCubit>().addDemo(),
              child: const Icon(Icons.add_rounded, size: 20),
            ),
          );
        },
      ),
    );
  }
}
