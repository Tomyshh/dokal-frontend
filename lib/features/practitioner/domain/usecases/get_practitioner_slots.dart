import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/practitioner_repository.dart';

class GetPractitionerSlots {
  GetPractitionerSlots(this.repo);

  final PractitionerRepository repo;

  Future<Either<Failure, List<Map<String, String>>>> call(
    String id, {
    required String from,
    required String to,
  }) =>
      repo.getSlots(id, from: from, to: to);
}
