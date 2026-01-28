import 'app_localizations.dart';
import 'app_locale_controller.dart';

AppLocalizations get l10nStatic {
  return lookupAppLocalizations(AppLocaleController.locale.value);
}
