part of 'messages_cubit.dart';

enum MessagesStatus { initial, loading, success, failure }

class MessagesState extends Equatable {
  const MessagesState({
    required this.status,
    required this.conversations,
    this.error,
  });

  const MessagesState.initial()
      : status = MessagesStatus.initial,
        conversations = const [],
        error = null;

  final MessagesStatus status;
  final List<ConversationPreview> conversations;
  final String? error;

  MessagesState copyWith({
    MessagesStatus? status,
    List<ConversationPreview>? conversations,
    String? error,
  }) {
    return MessagesState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, conversations, error];
}

