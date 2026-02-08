import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/review.dart';

abstract class ReviewsRepository {
  Future<Either<Failure, Review>> createReview({
    required String appointmentId,
    required String practitionerId,
    required int rating,
    String? comment,
  });
}
