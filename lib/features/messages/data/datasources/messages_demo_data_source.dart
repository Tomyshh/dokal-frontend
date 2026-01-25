import '../../domain/entities/chat_message.dart';
import '../../domain/entities/conversation_preview.dart';

abstract class MessagesDemoDataSource {
  List<ConversationPreview> listConversations();
  List<ChatMessage> getMessages(String conversationId);
  void appendMessage(String conversationId, ChatMessage message);
}

class MessagesDemoDataSourceImpl implements MessagesDemoDataSource {
  final _conversations = <ConversationPreview>[
    ConversationPreview(
      id: 'demo1',
      name: 'Dr Marc B.',
      lastMessage: 'Bonjour, vos résultats sont disponibles...',
      timeAgo: '5 min',
      unreadCount: 2,
      isOnline: true,
      avatarColorValue: 0xFF005044,
      appointment: ConversationAppointmentPreview(
        title: 'Consultation',
        date: 'Jeu 19 Fév',
      ),
    ),
    ConversationPreview(
      id: 'demo2',
      name: 'Cabinet Dentaire',
      lastMessage: 'Parfait, je vous envoie le document !',
      timeAgo: '2 h',
      unreadCount: 0,
      isOnline: false,
      avatarColorValue: 0xFF26A69A,
    ),
    ConversationPreview(
      id: 'demo3',
      name: 'Dr Sophie L.',
      lastMessage: 'Merci pour votre visite !',
      timeAgo: '1 j',
      unreadCount: 1,
      isOnline: true,
      avatarColorValue: 0xFFEC407A,
      appointment: ConversationAppointmentPreview(
        title: 'Suivi médical',
        date: 'Lun 15 Fév',
      ),
    ),
  ];

  final Map<String, List<ChatMessage>> _messages = {
    'demo1': const [
      ChatMessage(fromMe: false, text: 'Bonjour, comment pouvons-nous vous aider ?'),
      ChatMessage(fromMe: true, text: 'Bonjour, je souhaite obtenir mon compte-rendu.'),
      ChatMessage(
        fromMe: false,
        text: 'Bien sûr, pouvez-vous préciser la date du rendez-vous ?',
      ),
    ],
    'demo2': const [
      ChatMessage(fromMe: false, text: 'Bonjour, votre dossier est à jour.'),
    ],
    'demo3': const [
      ChatMessage(fromMe: false, text: 'Bonjour !'),
      ChatMessage(fromMe: true, text: 'Merci docteur.'),
    ],
  };

  @override
  List<ConversationPreview> listConversations() => List.unmodifiable(_conversations);

  @override
  List<ChatMessage> getMessages(String conversationId) {
    return List.unmodifiable(_messages[conversationId] ?? const <ChatMessage>[]);
  }

  @override
  void appendMessage(String conversationId, ChatMessage message) {
    final existing = _messages[conversationId] ?? <ChatMessage>[];
    _messages[conversationId] = [...existing, message];
  }
}

