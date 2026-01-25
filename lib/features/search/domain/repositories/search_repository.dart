import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/practitioner_search_result.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<PractitionerSearchResult>>> search({
    required String query,
  });
}

