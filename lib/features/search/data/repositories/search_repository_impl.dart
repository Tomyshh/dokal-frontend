import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/practitioner_search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({required this.remote});

  final SearchRemoteDataSourceImpl remote;

  @override
  Future<Either<Failure, List<PractitionerSearchResult>>> search({
    required String query,
  }) async {
    try {
      final results = await remote.searchAsync(query);
      return Right(results);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadSearch));
    }
  }
}
