import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/review.dart';
import '../repositories/reviews_repository.dart';

class CreateReview {
  CreateReview(this.repo);

  final ReviewsRepository repo;

  Future<Either<Failure, Review>> call({
    required String appointmentId,
    required String practitionerId,
    required int rating,
    String? comment,
  }) => repo.createReview(
    appointmentId: appointmentId,
    practitionerId: practitionerId,
    rating: rating,
    comment: comment,
  );
}
