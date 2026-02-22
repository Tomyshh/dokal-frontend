import 'package:flutter/foundation.dart';

/// Notifier appelé quand un rendez-vous est annulé ou modifié.
/// Permet à HomeCubit et AppointmentsCubit de rafraîchir leurs données.
class AppointmentRefreshNotifier extends ChangeNotifier {
  void notifyAppointmentChanged() {
    notifyListeners();
  }
}
