import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/documents_repository.dart';

class AddDemoDocument {
  AddDemoDocument(this.repo);

  final DocumentsRepository repo;

  Future<Either<Failure, Unit>> call() => repo.addDemo();
}

