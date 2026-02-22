import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/booking_repository.dart';

class ConfirmBooking {
  ConfirmBooking(this.repo);

  final BookingRepository repo;

  Future<Either<Failure, String>> call({
    required String practitionerId,
    required String reason,
    required String patientLabel,
    required String slotLabel,
    required String addressLine,
    required String zipCode,
    required String city,
    required bool visitedBefore,
    String? relativeId,
  }) => repo.confirm(
    practitionerId: practitionerId,
    reason: reason,
    patientLabel: patientLabel,
    slotLabel: slotLabel,
    addressLine: addressLine,
    zipCode: zipCode,
    city: city,
    visitedBefore: visitedBefore,
    relativeId: relativeId,
  );
}
