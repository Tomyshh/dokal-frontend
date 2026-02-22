import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/relative.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_data_source.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl({required this.remote});

  final AccountRemoteDataSourceImpl remote;

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final profile = await remote.getProfileAsync();
      return Right(profile);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadProfile));
    }
  }

  @override
  Future<Either<Failure, List<Relative>>> listRelatives() async {
    try {
      final relatives = await remote.listRelativesAsync();
      return Right(relatives);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadRelatives));
    }
  }

  @override
  Future<Either<Failure, Unit>> addRelativeDemo() async {
    // In production, this is a no-op placeholder. Real relative creation
    // happens through a dedicated form that calls addRelativeAsync().
    // For now, we keep backward compat with the demo flow.
    try {
      await remote.addRelativeAsync(
        firstName: 'Nouveau',
        lastName: 'Proche',
        relation: 'other',
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToAddRelative));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> listPaymentMethods() async {
    try {
      final methods = await remote.listPaymentMethodsAsync();
      return Right(methods);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadPayments));
    }
  }

  @override
  Future<Either<Failure, Unit>> addPaymentMethodDemo() async {
    try {
      await remote.addPaymentMethodAsync(
        brand: 'Visa',
        last4: '4242',
        expiryMonth: 12,
        expiryYear: 2027,
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToAddPaymentMethod));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
    String? dateOfBirth,
    String? sex,
  }) async {
    try {
      await remote.updateProfileAsync(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        city: city,
        dateOfBirth: dateOfBirth,
        sex: sex,
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }

  @override
  Future<Either<Failure, String?>> uploadAvatar(String filePath) async {
    try {
      final avatarUrl = await remote.uploadAvatarAsync(filePath);
      return Right(avatarUrl);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePaymentMethod(String id) async {
    try {
      await remote.deletePaymentMethod(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }

  @override
  Future<Either<Failure, Unit>> setDefaultPaymentMethod(String id) async {
    try {
      await remote.setDefaultPaymentMethod(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      await remote.deleteAccountAsync();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToDeleteAccount));
    }
  }
}
