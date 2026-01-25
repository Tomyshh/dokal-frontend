import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/practitioner_search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_demo_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({required this.demo});

  final SearchDemoDataSource demo;

  @override
  Future<Either<Failure, List<PractitionerSearchResult>>> search({
    required String query,
  }) async {
    try {
      return Right(demo.search(query));
    } catch (_) {
      return const Left(Failure('Impossible de charger la recherche.'));
    }
  }
}

