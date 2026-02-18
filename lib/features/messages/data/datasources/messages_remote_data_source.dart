import '../../../../core/network/api_client.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/conversation_preview.dart';
import 'messages_demo_data_source.dart';

/// Remote implementation of [MessagesDemoDataSource] backed by the Dokal
/// backend REST API.
class MessagesRemoteDataSourceImpl implements MessagesDemoDataSource {
  MessagesRemoteDataSourceImpl({
    required this.api,
    required this.currentUserId,
  });

  final ApiClient api;
  final String Function() currentUserId;

  // ---- sync stubs ----

  @override
  List<ConversationPreview> listConversations() =>
      throw UnimplementedError('Use listConversationsAsync');

  @override
  List<ChatMessage> getMessages(String conversationId) =>
      throw UnimplementedError('Use getMessagesAsync');

  @override
  void appendMessage(String conversationId, ChatMessage message) =>
      throw UnimplementedError('Use sendMessageAsync');

  // ---- async real implementations ----

  Future<List<ConversationPreview>> listConversationsAsync() async {
    final data = await api.get('/api/v1/conversations') as List<dynamic>;

    return data.map((raw) {
      final json = raw as Map<String, dynamic>;
      final practitioners = json['practitioners'] as Map<String, dynamic>?;
      final practProfiles = practitioners?['profiles'] as Map<String, dynamic>?;
      final lastMsg = json['last_message'] as Map<String, dynamic>?;

      final firstName = practProfiles?['first_name'] as String? ?? '';
      final lastName = practProfiles?['last_name'] as String? ?? '';

      // Appointment linked to conversation
      ConversationAppointmentPreview? appointment;
      final aptJson = json['appointments'];
      if (aptJson is Map<String, dynamic> && aptJson['id'] != null) {
        appointment = ConversationAppointmentPreview(
          title: aptJson['status'] as String? ?? '',
          date: aptJson['appointment_date'] as String? ?? '',
          isPast: false,
        );
      }

      return ConversationPreview(
        id: json['id'] as String,
        name: '$firstName $lastName'.trim(),
        lastMessage: lastMsg?['content'] as String? ?? '',
        timeAgo: _relativeTime(json['last_message_at'] as String?),
        unreadCount: json['unread_count'] as int? ?? 0,
        isOnline: false, // will be updated via socket/presence
        avatarColorValue:
            '$firstName$lastName'.hashCode & 0x00FFFFFF | 0xFF000000,
        appointment: appointment,
      );
    }).toList();
  }

  Future<List<ChatMessage>> getMessagesAsync(String conversationId) async {
    final data =
        await api.get(
              '/api/v1/conversations/$conversationId/messages',
              queryParameters: {'limit': 100},
            )
            as List<dynamic>;

    final uid = currentUserId();
    return data.map((raw) {
      final json = raw as Map<String, dynamic>;
      return ChatMessage(
        id: json['id'] as String? ?? '',
        fromMe: json['sender_id'] == uid,
        text: json['content'] as String? ?? '',
        createdAt: json['created_at'] as String? ?? '',
        messageType: json['message_type'] as String? ?? 'text',
      );
    }).toList();
  }

  Future<void> sendMessageAsync({
    required String conversationId,
    required String content,
  }) async {
    await api.post(
      '/api/v1/conversations/$conversationId/messages',
      data: {'content': content, 'message_type': 'text'},
    );
  }

  Future<void> markAsRead(String conversationId) async {
    await api.patch('/api/v1/conversations/$conversationId/read');
  }

  // ---- helpers ----

  static String _relativeTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      if (diff.inDays < 7) return '${diff.inDays}d';
      return '${(diff.inDays / 7).floor()}w';
    } catch (_) {
      return '';
    }
  }
}
