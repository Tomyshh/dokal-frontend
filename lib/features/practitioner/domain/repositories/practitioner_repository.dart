import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/practitioner_profile.dart';

abstract class PractitionerRepository {
  Future<Either<Failure, PractitionerProfile>> getById(String id);

  Future<Either<Failure, List<Map<String, String>>>> getSlots(
    String id, {
    required String from,
    required String to,
  });

  Future<Either<Failure, List<Map<String, dynamic>>>> getReviews(
    String id, {
    int limit = 20,
    int offset = 0,
  });
}
