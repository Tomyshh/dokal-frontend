import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/home_repository.dart';

class GetHomeHistoryEnabled {
  GetHomeHistoryEnabled(this.repo);

  final HomeRepository repo;

  Future<Either<Failure, bool>> call() => repo.isHistoryEnabled();
}

