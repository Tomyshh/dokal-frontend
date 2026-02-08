import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../l10n/l10n_static.dart';

abstract class HomeLocalDataSource {
  String getGreetingName();
  bool isHistoryEnabled();
  Future<void> enableHistory();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  HomeLocalDataSourceImpl({required this.prefs});

  final SharedPreferences prefs;

  static const _kGreetingName = 'home_greeting_name';
  static const _kHistoryEnabled = 'home_history_enabled';

  @override
  String getGreetingName() => prefs.getString(_kGreetingName) ?? '';

  @override
  bool isHistoryEnabled() => prefs.getBool(_kHistoryEnabled) ?? false;

  @override
  Future<void> enableHistory() async {
    final ok = await prefs.setBool(_kHistoryEnabled, true);
    if (!ok) {
      throw CacheException(l10nStatic.errorUnableToEnableHistory);
    }
  }
}
