import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/payment_method.dart';
import '../entities/relative.dart';
import '../entities/user_profile.dart';

abstract class AccountRepository {
  Future<Either<Failure, UserProfile>> getProfile();

  Future<Either<Failure, List<Relative>>> listRelatives();
  Future<Either<Failure, Unit>> addRelativeDemo();

  Future<Either<Failure, List<PaymentMethod>>> listPaymentMethods();
  Future<Either<Failure, Unit>> addPaymentMethodDemo();

  Future<Either<Failure, Unit>> requestPasswordChangeDemo();
}

