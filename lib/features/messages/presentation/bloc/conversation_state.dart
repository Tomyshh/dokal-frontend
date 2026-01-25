part of 'conversation_cubit.dart';

enum ConversationStatus { initial, loading, success, failure }

class ConversationState extends Equatable {
  const ConversationState({
    required this.status,
    required this.conversationId,
    required this.messages,
    this.error,
  });

  const ConversationState.initial({required this.conversationId})
      : status = ConversationStatus.initial,
        messages = const [],
        error = null;

  final ConversationStatus status;
  final String conversationId;
  final List<ChatMessage> messages;
  final String? error;

  ConversationState copyWith({
    ConversationStatus? status,
    List<ChatMessage>? messages,
    String? error,
  }) {
    return ConversationState(
      status: status ?? this.status,
      conversationId: conversationId,
      messages: messages ?? this.messages,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, conversationId, messages, error];
}

