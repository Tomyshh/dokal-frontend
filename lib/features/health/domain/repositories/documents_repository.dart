import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_document.dart';

abstract class DocumentsRepository {
  Future<Either<Failure, List<HealthDocument>>> list();
  Future<Either<Failure, Unit>> addDemo();
}

