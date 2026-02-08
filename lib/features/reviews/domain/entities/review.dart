import 'package:equatable/equatable.dart';

class Review extends Equatable {
  const Review({
    required this.id,
    required this.appointmentId,
    required this.practitionerId,
    required this.patientId,
    required this.rating,
    required this.createdAt,
    this.comment,
    this.practitionerReply,
    this.patientName,
  });

  final String id;
  final String appointmentId;
  final String practitionerId;
  final String patientId;
  final int rating;
  final String createdAt;
  final String? comment;
  final String? practitionerReply;
  final String? patientName;

  @override
  List<Object?> get props => [
    id,
    appointmentId,
    practitionerId,
    patientId,
    rating,
    createdAt,
    comment,
    practitionerReply,
    patientName,
  ];
}
