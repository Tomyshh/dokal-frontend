import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_document.dart';
import '../repositories/documents_repository.dart';

class GetDocuments {
  GetDocuments(this.repo);

  final DocumentsRepository repo;

  Future<Either<Failure, List<HealthDocument>>> call() => repo.list();
}

