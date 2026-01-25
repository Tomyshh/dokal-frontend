import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/payment_method.dart';
import '../bloc/payment_cubit.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PaymentCubit>(),
      child: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state.status == PaymentStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Erreur')),
            );
          }
        },
        builder: (context, state) {
          final List<PaymentMethod> items = state.items;
          return Scaffold(
            appBar: const DokalAppBar(title: 'Paiement'),
            body: state.status == PaymentStatus.loading
                ? const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: DokalLoader(lines: 5),
                  )
                : items.isEmpty
                    ? const DokalEmptyState(
                        title: 'Aucun moyen de paiement',
                        subtitle:
                            'Ajoutez une carte pour simplifier la facturation.',
                        icon: Icons.payments_rounded,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final pm = items[index];
                          return DokalCard(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(AppRadii.sm),
                                  ),
                                  child: const Icon(
                                    Icons.credit_card_rounded,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${pm.brandLabel} •••• ${pm.last4}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Expire ${pm.expiry}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
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
              onPressed: () => context.read<PaymentCubit>().addDemo(),
              child: const Icon(Icons.add_rounded, size: 20),
            ),
          );
        },
      ),
    );
  }
}

