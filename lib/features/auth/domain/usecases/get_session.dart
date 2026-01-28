import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class GetSession {
  const GetSession(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, AuthSession?>> call() => _repo.getSession();
}
