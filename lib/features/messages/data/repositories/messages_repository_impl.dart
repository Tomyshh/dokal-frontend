import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/conversation_preview.dart';
import '../../domain/repositories/messages_repository.dart';
import '../datasources/messages_demo_data_source.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl({required this.demo});

  final MessagesDemoDataSource demo;

  @override
  Future<Either<Failure, List<ConversationPreview>>> listConversations() async {
    try {
      return Right(demo.listConversations());
    } catch (_) {
      return const Left(Failure('Impossible de charger les conversations.'));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getConversationMessages(
    String conversationId,
  ) async {
    try {
      return Right(demo.getMessages(conversationId));
    } catch (_) {
      return const Left(Failure('Impossible de charger la conversation.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    try {
      demo.appendMessage(conversationId, ChatMessage(fromMe: true, text: text));
      return const Right(unit);
    } catch (_) {
      return const Left(Failure("Impossible d'envoyer le message."));
    }
  }
}

