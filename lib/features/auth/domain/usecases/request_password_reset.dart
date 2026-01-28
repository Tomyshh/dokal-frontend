import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

class RequestPasswordReset {
  const RequestPasswordReset(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, Unit>> call({required String email}) =>
      _repo.requestPasswordReset(email: email);
}
