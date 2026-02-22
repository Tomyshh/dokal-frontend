import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/appointment.dart';
import '../repositories/appointments_repository.dart';

class RescheduleAppointment {
  RescheduleAppointment(this.repo);

  final AppointmentsRepository repo;

  Future<Either<Failure, Appointment>> call(
    String id, {
    required String appointmentDate,
    required String startTime,
    required String endTime,
  }) =>
      repo.reschedule(
        id,
        appointmentDate: appointmentDate,
        startTime: startTime,
        endTime: endTime,
      );
}
