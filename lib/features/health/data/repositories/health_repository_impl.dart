import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/health_item.dart';
import '../../domain/repositories/health_repository.dart';
import '../datasources/health_demo_data_source.dart';

class HealthRepositoryImpl implements HealthRepository {
  HealthRepositoryImpl({required this.demo});

  final HealthDemoDataSource demo;

  @override
  Future<Either<Failure, List<HealthItem>>> list(HealthListType type) async {
    try {
      return Right(demo.list(type));
    } catch (_) {
      return const Left(Failure('Impossible de charger les données santé.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addDemo(HealthListType type) async {
    try {
      demo.addDemo(type);
      return const Right(unit);
    } catch (_) {
      return const Left(Failure('Impossible d’ajouter un élément.'));
    }
  }
}

