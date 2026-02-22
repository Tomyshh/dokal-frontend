import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({required this.remote});

  final BookingRemoteDataSourceImpl remote;

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
    String? relativeId,
  }) async {
    try {
      // Parse the slotLabel to extract date & times.
      // The booking flow provides structured data; slotLabel format:
      // "YYYY-MM-DD|HH:mm|HH:mm" (date|start|end) for real backend calls.
      String appointmentDate = '';
      String startTime = '';
      String endTime = '';

      if (slotLabel.contains('|')) {
        final parts = slotLabel.split('|');
        appointmentDate = parts[0];
        startTime = parts.length > 1 ? parts[1] : '';
        endTime = parts.length > 2 ? parts[2] : '';
      } else {
        // Fallback: use as-is
        appointmentDate = slotLabel;
        startTime = '09:00:00';
        endTime = '09:30:00';
      }

      final id = await remote.confirmStructured(
        practitionerId: practitionerId,
        relativeId: relativeId,
        reasonId: reason.isNotEmpty ? reason : null,
        appointmentDate: appointmentDate,
        startTime: startTime,
        endTime: endTime,
        addressLine: addressLine.trim().isEmpty ? null : addressLine.trim(),
        zipCode: zipCode.trim().isEmpty ? null : zipCode.trim(),
        city: city.trim().isEmpty ? null : city.trim(),
        visitedBefore: visitedBefore,
      );
      return Right(id);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToConfirmAppointment));
    }
  }
}
