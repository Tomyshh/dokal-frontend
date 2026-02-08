import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/health_profile.dart';
import '../../domain/repositories/health_profile_repository.dart';
import '../datasources/health_profile_remote_data_source.dart';

class HealthProfileRepositoryImpl implements HealthProfileRepository {
  HealthProfileRepositoryImpl({required this.remote});

  final HealthProfileRemoteDataSourceImpl remote;

  @override
  Future<Either<Failure, HealthProfile?>> getProfile() async {
    try {
      final profile = await remote.getProfileAsync();
      return Right(profile);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadHealthProfile));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveProfile(HealthProfile profile) async {
    try {
      await remote.saveProfileAsync(profile);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToSaveHealthProfile));
    }
  }
}
