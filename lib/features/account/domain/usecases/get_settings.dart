import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class GetSettings {
  GetSettings(this.repo);

  final SettingsRepository repo;

  Future<Either<Failure, AppSettings>> call() => repo.getSettings();
}
