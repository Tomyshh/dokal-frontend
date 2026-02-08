import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/home_practitioner.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.local, required this.api});

  final HomeLocalDataSource local;
  final ApiClient api;

  @override
  Future<Either<Failure, String>> getGreetingName() async {
    try {
      // Fetch real name from backend profile
      final json = await api.get('/api/v1/profile') as Map<String, dynamic>;
      final firstName = json['first_name'] as String?;
      if (firstName != null && firstName.isNotEmpty) {
        return Right(firstName);
      }
      return Right(local.getGreetingName());
    } on ServerException {
      // Fallback to local if backend unavailable
      return Right(local.getGreetingName());
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadProfile));
    }
  }

  @override
  Future<Either<Failure, bool>> isHistoryEnabled() async {
    try {
      return Right(local.isHistoryEnabled());
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToReadHistoryState));
    }
  }

  @override
  Future<Either<Failure, Unit>> enableHistory() async {
    try {
      await local.enableHistory();
      return const Right(unit);
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToEnableHistory));
    }
  }

  @override
  Future<Either<Failure, List<HomePractitioner>>>
      getRecentPractitioners() async {
    try {
      // Recent practitioners come from past appointments
      final data =
          await api.get('/api/v1/appointments/past') as List<dynamic>;
      final seen = <String>{};
      final result = <HomePractitioner>[];
      for (final raw in data) {
        final json = raw as Map<String, dynamic>;
        final practitioners =
            json['practitioners'] as Map<String, dynamic>?;
        if (practitioners == null) continue;
        final pId = practitioners['id'] as String?;
        if (pId == null || seen.contains(pId)) continue;
        seen.add(pId);
        final profiles =
            practitioners['profiles'] as Map<String, dynamic>?;
        final specialties =
            practitioners['specialties'] as Map<String, dynamic>?;
        final firstName =
            profiles?['first_name'] as String? ?? '';
        final lastName = profiles?['last_name'] as String? ?? '';
        result.add(HomePractitioner(
          id: pId,
          name: '$firstName $lastName'.trim(),
          specialty: specialties?['name_fr'] as String? ??
              specialties?['name'] as String? ??
              '',
        ));
        if (result.length >= 3) break;
      }
      return Right(result);
    } on ServerException {
      return const Right(<HomePractitioner>[]);
    } catch (_) {
      return const Right(<HomePractitioner>[]);
    }
  }
}
