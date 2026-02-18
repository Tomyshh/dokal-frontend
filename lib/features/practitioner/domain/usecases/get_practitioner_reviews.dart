import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/practitioner_repository.dart';

class GetPractitionerReviews {
  GetPractitionerReviews(this.repo);

  final PractitionerRepository repo;

  Future<Either<Failure, List<Map<String, dynamic>>>> call(
    String id, {
    int limit = 20,
    int offset = 0,
  }) => repo.getReviews(id, limit: limit, offset: offset);
}
