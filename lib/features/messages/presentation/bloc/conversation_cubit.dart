import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_conversation_messages.dart';
import '../../domain/usecases/send_message.dart';

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  ConversationCubit({
    required GetConversationMessages getConversationMessages,
    required SendMessage sendMessage,
    required String conversationId,
  }) : _getConversationMessages = getConversationMessages,
       _sendMessage = sendMessage,
       super(ConversationState.initial(conversationId: conversationId));

  final GetConversationMessages _getConversationMessages;
  final SendMessage _sendMessage;

  Future<void> load() async {
    emit(state.copyWith(status: ConversationStatus.loading));
    final res = await _getConversationMessages(state.conversationId);
    res.fold(
      (f) => emit(
        state.copyWith(status: ConversationStatus.failure, error: f.message),
      ),
      (items) => emit(
        state.copyWith(
          status: ConversationStatus.success,
          messages: items,
          error: null,
        ),
      ),
    );
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final res = await _sendMessage(
      conversationId: state.conversationId,
      text: trimmed,
    );
    res.fold(
      (f) => emit(
        state.copyWith(status: ConversationStatus.failure, error: f.message),
      ),
      (_) async {
        await load();
      },
    );
  }
}
