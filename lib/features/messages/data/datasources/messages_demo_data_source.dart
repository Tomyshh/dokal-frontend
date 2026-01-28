import '../../domain/entities/chat_message.dart';
import '../../domain/entities/conversation_preview.dart';
import '../../../../l10n/l10n_static.dart';

abstract class MessagesDemoDataSource {
  List<ConversationPreview> listConversations();
  List<ChatMessage> getMessages(String conversationId);
  void appendMessage(String conversationId, ChatMessage message);
}

class MessagesDemoDataSourceImpl implements MessagesDemoDataSource {
  final Map<String, List<ChatMessage>> _messages = {};

  List<ConversationPreview> _buildConversations() {
    final l10n = l10nStatic;
    return [
      ConversationPreview(
        id: 'demo1',
        name: l10n.demoPractitionerNameMarcShort,
        lastMessage: l10n.demoConversation1LastMessage,
        timeAgo: l10n.timeMinutesAgo(5),
        unreadCount: 2,
        isOnline: true,
        avatarColorValue: 0xFF005044,
        appointment: ConversationAppointmentPreview(
          title: l10n.demoAppointmentConsultation,
          date: l10n.demoShortDateThu19Feb,
          isPast: false,
        ),
      ),
      ConversationPreview(
        id: 'demo2',
        name: l10n.demoDentalOfficeName,
        lastMessage: l10n.demoConversation2LastMessage,
        timeAgo: l10n.timeHoursAgo(2),
        unreadCount: 0,
        isOnline: false,
        avatarColorValue: 0xFF26A69A,
      ),
      ConversationPreview(
        id: 'demo3',
        name: l10n.demoPractitionerNameSophie,
        lastMessage: l10n.demoConversation3LastMessage,
        timeAgo: l10n.timeDaysAgo(1),
        unreadCount: 1,
        isOnline: true,
        avatarColorValue: 0xFFEC407A,
        appointment: ConversationAppointmentPreview(
          title: l10n.demoAppointmentFollowUp,
          date: l10n.demoShortDateMon15Feb,
          isPast: true,
        ),
      ),
    ];
  }

  List<ChatMessage> _buildMessages(String conversationId) {
    final l10n = l10nStatic;
    return switch (conversationId) {
      'demo1' => [
        ChatMessage(fromMe: false, text: l10n.demoMessage1_1),
        ChatMessage(fromMe: true, text: l10n.demoMessage1_2),
        ChatMessage(fromMe: false, text: l10n.demoMessage1_3),
      ],
      'demo2' => [ChatMessage(fromMe: false, text: l10n.demoMessage2_1)],
      'demo3' => [
        ChatMessage(fromMe: false, text: l10n.demoMessage3_1),
        ChatMessage(fromMe: true, text: l10n.demoMessage3_2),
      ],
      _ => const <ChatMessage>[],
    };
  }

  @override
  List<ConversationPreview> listConversations() =>
      List.unmodifiable(_buildConversations());

  @override
  List<ChatMessage> getMessages(String conversationId) {
    _messages.putIfAbsent(conversationId, () => _buildMessages(conversationId));
    return List.unmodifiable(
      _messages[conversationId] ?? const <ChatMessage>[],
    );
  }

  @override
  void appendMessage(String conversationId, ChatMessage message) {
    final existing =
        _messages[conversationId] ?? _buildMessages(conversationId);
    _messages[conversationId] = [...existing, message];
  }
}
