import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/reviews_repository.dart';
import '../datasources/reviews_remote_data_source.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  ReviewsRepositoryImpl({required this.remote});

  final ReviewsRemoteDataSourceImpl remote;

  @override
  Future<Either<Failure, Review>> createReview({
    required String appointmentId,
    required String practitionerId,
    required int rating,
    String? comment,
  }) async {
    try {
      final review = await remote.createReviewAsync(
        appointmentId: appointmentId,
        practitionerId: practitionerId,
        rating: rating,
        comment: comment,
      );
      return Right(review);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure('Unable to submit review'));
    }
  }
}
