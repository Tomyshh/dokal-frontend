import 'package:flutter/foundation.dart';

/// Notifier appelé quand l'utilisateur revient d'une conversation.
/// Permet à MessagesCubit de rafraîchir la liste des conversations.
class MessagesRefreshNotifier extends ChangeNotifier {
  void notifyMessagesChanged() {
    notifyListeners();
  }
}
