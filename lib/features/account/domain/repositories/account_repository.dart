import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/payment_method.dart';
import '../entities/relative.dart';
import '../entities/user_profile.dart';

abstract class AccountRepository {
  Future<Either<Failure, UserProfile>> getProfile();

  Future<Either<Failure, List<Relative>>> listRelatives();
  Future<Either<Failure, Unit>> addRelativeDemo();
  Future<Either<Failure, Relative>> addRelative({
    required String firstName,
    required String lastName,
    required String teudatZehut,
    String? dateOfBirth,
    required String relation,
    String? kupatHolim,
    String? insuranceProvider,
    String? avatarUrl,
  });

  Future<Either<Failure, Unit>> updateRelative({
    required String id,
    required String firstName,
    required String lastName,
    required String teudatZehut,
    String? dateOfBirth,
    required String relation,
    String? kupatHolim,
    String? insuranceProvider,
    String? avatarUrl,
  });

  /// Upload l'avatar d'un proche. Retourne l'URL ou une erreur.
  Future<Either<Failure, String?>> uploadRelativeAvatar(String relativeId, String filePath);

  Future<Either<Failure, Unit>> deleteRelative(String id);

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
