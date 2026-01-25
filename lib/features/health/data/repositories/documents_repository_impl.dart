import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/health_document.dart';
import '../../domain/repositories/documents_repository.dart';
import '../datasources/documents_demo_data_source.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  DocumentsRepositoryImpl({required this.demo});

  final DocumentsDemoDataSource demo;

  @override
  Future<Either<Failure, List<HealthDocument>>> list() async {
    try {
      return Right(demo.list());
    } catch (_) {
      return const Left(Failure('Impossible de charger les documents.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addDemo() async {
    try {
      demo.addDemo();
      return const Right(unit);
    } catch (_) {
      return const Left(Failure('Impossible d’ajouter le document.'));
    }
  }
}

