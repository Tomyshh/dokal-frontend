import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/account_repository.dart';

class UploadAvatar {
  UploadAvatar(this.repo);

  final AccountRepository repo;

  Future<Either<Failure, String?>> call(String filePath) =>
      repo.uploadAvatar(filePath);
}
