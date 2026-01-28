import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/home_repository.dart';

class GetHomeGreetingName {
  GetHomeGreetingName(this.repo);

  final HomeRepository repo;

  Future<Either<Failure, String>> call() => repo.getGreetingName();
}
