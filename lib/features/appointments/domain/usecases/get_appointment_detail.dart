import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/appointment.dart';
import '../repositories/appointments_repository.dart';

class GetAppointmentDetail {
  GetAppointmentDetail(this.repo);

  final AppointmentsRepository repo;

  Future<Either<Failure, Appointment?>> call(String id) => repo.getById(id);
}

