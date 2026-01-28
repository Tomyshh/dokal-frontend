import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/add_payment_method_demo.dart';
import '../../domain/usecases/get_payment_methods.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit({
    required GetPaymentMethods getPaymentMethods,
    required AddPaymentMethodDemo addPaymentMethodDemo,
  }) : _getPaymentMethods = getPaymentMethods,
       _addPaymentMethodDemo = addPaymentMethodDemo,
       super(const PaymentState.initial());

  final GetPaymentMethods _getPaymentMethods;
  final AddPaymentMethodDemo _addPaymentMethodDemo;

  Future<void> load() async {
    emit(state.copyWith(status: PaymentStatus.loading));
    final res = await _getPaymentMethods();
    res.fold(
      (f) =>
          emit(state.copyWith(status: PaymentStatus.failure, error: f.message)),
      (items) => emit(
        state.copyWith(
          status: PaymentStatus.success,
          items: items,
          error: null,
        ),
      ),
    );
  }

  Future<void> addDemo() async {
    final res = await _addPaymentMethodDemo();
    res.fold(
      (f) =>
          emit(state.copyWith(status: PaymentStatus.failure, error: f.message)),
      (_) async => load(),
    );
  }
}
