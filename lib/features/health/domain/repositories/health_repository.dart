import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_item.dart';

enum HealthListType { conditions, medications, allergies, vaccinations }

abstract class HealthRepository {
  Future<Either<Failure, List<HealthItem>>> list(HealthListType type);
  Future<Either<Failure, Unit>> addDemo(HealthListType type);
}

