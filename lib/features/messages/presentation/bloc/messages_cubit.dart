import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/conversation_preview.dart';
import '../../domain/usecases/get_conversations.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit({required GetConversations getConversations})
    : _getConversations = getConversations,
      super(const MessagesState.initial());

  final GetConversations _getConversations;

  Future<void> load() async {
    // Mode invité: la messagerie est liée à un compte.
    // Sans session, on affiche simplement un état vide au lieu d'un 401.
    final hasSession = Supabase.instance.client.auth.currentSession != null;
    if (!hasSession) {
      emit(
        state.copyWith(
          status: MessagesStatus.success,
          conversations: const <ConversationPreview>[],
          error: null,
        ),
      );
      return;
    }

    emit(state.copyWith(status: MessagesStatus.loading));
    final res = await _getConversations();
    res.fold(
      (f) => emit(
        state.copyWith(status: MessagesStatus.failure, error: f.message),
      ),
      (items) => emit(
        state.copyWith(
          status: MessagesStatus.success,
          conversations: items,
          error: null,
        ),
      ),
    );
  }
}
