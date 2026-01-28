import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/home_practitioner.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.local});

  final HomeLocalDataSource local;

  @override
  Future<Either<Failure, String>> getGreetingName() async {
    try {
      return Right(local.getGreetingName());
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadProfile));
    }
  }

  @override
  Future<Either<Failure, bool>> isHistoryEnabled() async {
    try {
      return Right(local.isHistoryEnabled());
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToReadHistoryState));
    }
  }

  @override
  Future<Either<Failure, Unit>> enableHistory() async {
    try {
      await local.enableHistory();
      return const Right(unit);
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToEnableHistory));
    }
  }

  @override
  Future<Either<Failure, List<HomePractitioner>>>
  getRecentPractitioners() async {
    // Démo: vide (sera alimenté depuis backend plus tard).
    return const Right(<HomePractitioner>[]);
  }
}
