import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/relative.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_demo_data_source.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl({required this.demo});

  final AccountDemoDataSource demo;

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      return Right(demo.getProfile());
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadProfile));
    }
  }

  @override
  Future<Either<Failure, List<Relative>>> listRelatives() async {
    try {
      return Right(demo.listRelatives());
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadRelatives));
    }
  }

  @override
  Future<Either<Failure, Unit>> addRelativeDemo() async {
    try {
      demo.addRelativeDemo();
      return const Right(unit);
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToAddRelative));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> listPaymentMethods() async {
    try {
      return Right(demo.listPaymentMethods());
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadPayments));
    }
  }

  @override
  Future<Either<Failure, Unit>> addPaymentMethodDemo() async {
    try {
      demo.addPaymentMethodDemo();
      return const Right(unit);
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToAddPaymentMethod));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestPasswordChangeDemo() async {
    // Placeholder: brancher au backend plus tard (reset password / update password).
    return const Right(unit);
  }
}
