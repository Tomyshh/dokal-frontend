import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/home_repository.dart';

class EnableHomeHistory {
  EnableHomeHistory(this.repo);

  final HomeRepository repo;

  Future<Either<Failure, Unit>> call() => repo.enableHistory();
}

