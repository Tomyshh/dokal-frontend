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

  Future<Either<Failure, Unit>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
    String? dateOfBirth,
    String? sex,
  });

  Future<Either<Failure, String?>> uploadAvatar(String filePath);

  Future<Either<Failure, Unit>> deletePaymentMethod(String id);

  Future<Either<Failure, Unit>> setDefaultPaymentMethod(String id);

  /// Supprime définitivement le compte courant (et ses entités associées).
  Future<Either<Failure, Unit>> deleteAccount();
}
