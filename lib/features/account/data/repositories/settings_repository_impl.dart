import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.local});

  final SettingsLocalDataSource local;

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      return Right(local.getSettings());
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToReadSettings));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSettings(AppSettings settings) async {
    try {
      await local.saveSettings(settings);
      return const Right(unit);
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToSaveSettings));
    }
  }
}
