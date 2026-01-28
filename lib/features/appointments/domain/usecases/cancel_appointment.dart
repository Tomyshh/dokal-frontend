import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/appointments_repository.dart';

class CancelAppointment {
  CancelAppointment(this.repo);

  final AppointmentsRepository repo;

  Future<Either<Failure, Unit>> call(String id) => repo.cancel(id);
}
