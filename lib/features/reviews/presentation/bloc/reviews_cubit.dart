import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_review.dart';
import 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit({required CreateReview createReview})
    : _createReview = createReview,
      super(const ReviewsState.initial());

  final CreateReview _createReview;

  /// Submits a review for an appointment.
  ///
  /// Parameters:
  ///   - appointmentId: The UUID of the appointment being reviewed
  ///   - practitionerId: The UUID of the practitioner being reviewed
  ///   - rating: The rating given (1-5)
  ///   - comment: Optional comment/review text
  Future<void> submit({
    required String appointmentId,
    required String practitionerId,
    required int rating,
    String? comment,
  }) async {
    emit(state.copyWith(status: ReviewsStatus.loading));

    final result = await _createReview(
      appointmentId: appointmentId,
      practitionerId: practitionerId,
      rating: rating,
      comment: comment,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewsStatus.failure, error: failure.message),
      ),
      (review) => emit(
        state.copyWith(
          status: ReviewsStatus.success,
          review: review,
          error: null,
        ),
      ),
    );
  }

  /// Resets the state to initial.
  void reset() {
    emit(const ReviewsState.initial());
  }
}
