import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../datasources/appointments_demo_data_source.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  AppointmentsRepositoryImpl({required this.demo});

  final AppointmentsDemoDataSource demo;

  @override
  Future<Either<Failure, List<Appointment>>> listUpcoming() async {
    try {
      return Right(demo.upcoming());
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadUpcomingAppointments));
    }
  }

  @override
  Future<Either<Failure, List<Appointment>>> listPast() async {
    try {
      return Right(demo.past());
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadHistory));
    }
  }

  @override
  Future<Either<Failure, Appointment?>> getById(String id) async {
    try {
      return Right(demo.getById(id));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadAppointment));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancel(String id) async {
    try {
      demo.cancel(id);
      return const Right(unit);
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToCancelAppointment));
    }
  }
}
