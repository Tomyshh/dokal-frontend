import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/health_profile.dart';

abstract class HealthProfileLocalDataSource {
  HealthProfile? getProfile();
  Future<void> saveProfile(HealthProfile profile);
}

class HealthProfileLocalDataSourceImpl implements HealthProfileLocalDataSource {
  HealthProfileLocalDataSourceImpl({required this.prefs});

  static const _kHealthProfile = 'health_profile_json';

  final SharedPreferences prefs;

  @override
  HealthProfile? getProfile() {
    try {
      final raw = prefs.getString(_kHealthProfile);
      if (raw == null || raw.isEmpty) return null;
      return HealthProfile.fromJsonString(raw);
    } catch (_) {
      throw CacheException(l10nStatic.errorUnableToLoadHealthProfile);
    }
  }

  @override
  Future<void> saveProfile(HealthProfile profile) async {
    final ok = await prefs.setString(_kHealthProfile, profile.toJsonString());
    if (!ok) {
      throw CacheException(l10nStatic.errorUnableToSaveHealthProfile);
    }
  }
}
