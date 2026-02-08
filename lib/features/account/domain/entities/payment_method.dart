import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  const PaymentMethod({
    required this.id,
    required this.brandLabel,
    required this.last4,
    required this.expiry,
    this.isDefault = false,
  });

  final String id;
  final String brandLabel;
  final String last4;
  final String expiry;
  final bool isDefault;

  @override
  List<Object?> get props => [id, brandLabel, last4, expiry, isDefault];
}
