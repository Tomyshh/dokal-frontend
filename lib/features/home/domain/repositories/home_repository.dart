import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/home_practitioner.dart';

abstract class HomeRepository {
  Future<Either<Failure, String>> getGreetingName();
  Future<Either<Failure, bool>> isHistoryEnabled();
  Future<Either<Failure, Unit>> enableHistory();
  Future<Either<Failure, List<HomePractitioner>>> getRecentPractitioners();
}
