import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_profile.dart';
import '../repositories/account_repository.dart';

class GetProfile {
  GetProfile(this.repo);

  final AccountRepository repo;

  Future<Either<Failure, UserProfile>> call() => repo.getProfile();
}
