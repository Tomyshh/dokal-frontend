import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/conversation_preview.dart';
import '../../domain/usecases/get_conversations.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit({required GetConversations getConversations})
      : _getConversations = getConversations,
        super(const MessagesState.initial());

  final GetConversations _getConversations;

  Future<void> load() async {
    emit(state.copyWith(status: MessagesStatus.loading));
    final res = await _getConversations();
    res.fold(
      (f) => emit(state.copyWith(status: MessagesStatus.failure, error: f.message)),
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

