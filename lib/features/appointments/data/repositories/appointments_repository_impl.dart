import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../datasources/appointments_remote_data_source.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  AppointmentsRepositoryImpl({required this.remote});

  final AppointmentsRemoteDataSourceImpl remote;

  @override
  Future<Either<Failure, List<Appointment>>> listUpcoming() async {
    try {
      final list = await remote.upcomingAsync();
      return Right(list);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadUpcomingAppointments));
    }
  }

  @override
  Future<Either<Failure, List<Appointment>>> listPast() async {
    try {
      final list = await remote.pastAsync();
      return Right(list);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadHistory));
    }
  }

  @override
  Future<Either<Failure, Appointment?>> getById(String id) async {
    try {
      final appointment = await remote.getByIdAsync(id);
      return Right(appointment);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadAppointment));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancel(String id) async {
    try {
      await remote.cancelAsync(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToCancelAppointment));
    }
  }

  @override
  Future<Either<Failure, Appointment>> reschedule(
    String id, {
    required String appointmentDate,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final appointment = await remote.rescheduleAsync(
        id,
        appointmentDate: appointmentDate,
        startTime: startTime,
        endTime: endTime,
      );
      if (appointment == null) {
        return Left(Failure(l10nStatic.errorUnableToRescheduleAppointment));
      }
      return Right(appointment);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToRescheduleAppointment));
    }
  }
}
