import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
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
      return const Left(Failure("Impossible de charger les rendez-vous à venir."));
    }
  }

  @override
  Future<Either<Failure, List<Appointment>>> listPast() async {
    try {
      return Right(demo.past());
    } catch (_) {
      return const Left(Failure("Impossible de charger l'historique."));
    }
  }

  @override
  Future<Either<Failure, Appointment?>> getById(String id) async {
    try {
      return Right(demo.getById(id));
    } catch (_) {
      return const Left(Failure("Impossible de charger le rendez-vous."));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancel(String id) async {
    try {
      demo.cancel(id);
      return const Right(unit);
    } catch (_) {
      return const Left(Failure("Impossible d'annuler le rendez-vous."));
    }
  }
}

