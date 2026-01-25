import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/practitioner_profile.dart';
import '../../domain/repositories/practitioner_repository.dart';
import '../datasources/practitioner_demo_data_source.dart';

class PractitionerRepositoryImpl implements PractitionerRepository {
  PractitionerRepositoryImpl({required this.demo});

  final PractitionerDemoDataSource demo;

  @override
  Future<Either<Failure, PractitionerProfile>> getById(String id) async {
    try {
      return Right(demo.getById(id));
    } catch (_) {
      return const Left(Failure('Impossible de charger le praticien.'));
    }
  }
}

