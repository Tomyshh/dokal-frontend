import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_demo_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({required this.demo});

  final BookingDemoDataSource demo;

  @override
  Future<Either<Failure, String>> confirm({
    required String practitionerId,
    required String reason,
    required String patientLabel,
    required String slotLabel,
    required String addressLine,
    required String zipCode,
    required String city,
    required bool visitedBefore,
  }) async {
    try {
      final id = await demo.confirm(
        practitionerId: practitionerId,
        reason: reason,
        patientLabel: patientLabel,
        slotLabel: slotLabel,
        addressLine: addressLine,
        zipCode: zipCode,
        city: city,
        visitedBefore: visitedBefore,
      );
      return Right(id);
    } catch (_) {
      return const Left(Failure("Impossible de confirmer le rendez-vous."));
    }
  }
}

