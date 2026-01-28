import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

abstract class BookingRepository {
  Future<Either<Failure, String>> confirm({
    required String practitionerId,
    required String reason,
    required String patientLabel,
    required String slotLabel,
    required String addressLine,
    required String zipCode,
    required String city,
    required bool visitedBefore,
  });
}
