import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/practitioner_search_result.dart';
import '../repositories/search_repository.dart';

class SearchPractitioners {
  SearchPractitioners(this.repo);

  final SearchRepository repo;

  Future<Either<Failure, List<PractitionerSearchResult>>> call(String query) =>
      repo.search(query: query);
}

