import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/appointment.dart';

abstract class AppointmentsRepository {
  Future<Either<Failure, List<Appointment>>> listUpcoming();
  Future<Either<Failure, List<Appointment>>> listPast();
  Future<Either<Failure, Appointment?>> getById(String id);
  Future<Either<Failure, Unit>> cancel(String id);
}

