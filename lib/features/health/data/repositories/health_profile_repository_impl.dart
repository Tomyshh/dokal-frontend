import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/health_profile.dart';
import '../../domain/repositories/health_profile_repository.dart';
import '../datasources/health_profile_local_data_source.dart';

class HealthProfileRepositoryImpl implements HealthProfileRepository {
  HealthProfileRepositoryImpl({required this.local});

  final HealthProfileLocalDataSource local;

  @override
  Future<Either<Failure, HealthProfile?>> getProfile() async {
    try {
      return Right(local.getProfile());
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadHealthProfile));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveProfile(HealthProfile profile) async {
    try {
      await local.saveProfile(profile);
      return const Right(unit);
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToSaveHealthProfile));
    }
  }
}
