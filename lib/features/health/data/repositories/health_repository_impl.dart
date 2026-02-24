import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/health_item.dart';
import '../../domain/repositories/health_repository.dart';
import '../datasources/health_remote_data_source.dart';

class HealthRepositoryImpl implements HealthRepository {
  HealthRepositoryImpl({required this.remote});

  final HealthRemoteDataSourceImpl remote;

  @override
  Future<Either<Failure, List<HealthItem>>> list(HealthListType type) async {
    try {
      final items = await remote.listAsync(type);
      return Right(items);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadHealthData));
    }
  }

}
