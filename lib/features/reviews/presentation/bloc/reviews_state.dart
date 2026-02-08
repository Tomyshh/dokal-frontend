import 'package:equatable/equatable.dart';

import '../../domain/entities/review.dart';

enum ReviewsStatus { initial, loading, success, failure }

class ReviewsState extends Equatable {
  const ReviewsState({
    required this.status,
    this.review,
    this.error,
  });

  const ReviewsState.initial()
    : status = ReviewsStatus.initial,
      review = null,
      error = null;

  final ReviewsStatus status;
  final Review? review;
  final String? error;

  ReviewsState copyWith({
    ReviewsStatus? status,
    Review? review,
    String? error,
  }) {
    return ReviewsState(
      status: status ?? this.status,
      review: review ?? this.review,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, review, error];
}
