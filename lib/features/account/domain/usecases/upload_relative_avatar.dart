import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/account_repository.dart';

class UploadRelativeAvatar {
  UploadRelativeAvatar(this.repo);

  final AccountRepository repo;

  Future<Either<Failure, String?>> call(String relativeId, String filePath) =>
      repo.uploadRelativeAvatar(relativeId, filePath);
}
