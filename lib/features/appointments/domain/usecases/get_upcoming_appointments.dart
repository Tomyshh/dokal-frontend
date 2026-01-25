import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/appointment.dart';
import '../repositories/appointments_repository.dart';

class GetUpcomingAppointments {
  GetUpcomingAppointments(this.repo);

  final AppointmentsRepository repo;

  Future<Either<Failure, List<Appointment>>> call() => repo.listUpcoming();
}

