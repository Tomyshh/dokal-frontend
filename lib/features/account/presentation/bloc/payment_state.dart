part of 'payment_cubit.dart';

enum PaymentStatus { initial, loading, success, failure }

class PaymentState extends Equatable {
  const PaymentState({required this.status, required this.items, this.error});

  const PaymentState.initial()
    : status = PaymentStatus.initial,
      items = const [],
      error = null;

  final PaymentStatus status;
  final List<PaymentMethod> items;
  final String? error;

  PaymentState copyWith({
    PaymentStatus? status,
    List<PaymentMethod>? items,
    String? error,
  }) {
    return PaymentState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, error];
}
