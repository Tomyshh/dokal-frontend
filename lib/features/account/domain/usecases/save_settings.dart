import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class SaveSettings {
  SaveSettings(this.repo);

  final SettingsRepository repo;

  Future<Either<Failure, Unit>> call(AppSettings settings) =>
      repo.saveSettings(settings);
}

