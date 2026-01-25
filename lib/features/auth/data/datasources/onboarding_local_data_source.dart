import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';

abstract class OnboardingLocalDataSource {
  bool isCompleted();
  Future<void> setCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl({required this.prefs});

  static const _key = 'onboarding_completed';

  final SharedPreferences prefs;

  @override
  bool isCompleted() => prefs.getBool(_key) ?? false;

  @override
  Future<void> setCompleted() async {
    final ok = await prefs.setBool(_key, true);
    if (!ok) {
      throw const CacheException("Impossible d'enregistrer l'onboarding.");
    }
  }
}

