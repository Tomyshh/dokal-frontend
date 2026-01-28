import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/chat_message.dart';
import '../entities/conversation_preview.dart';

abstract class MessagesRepository {
  Future<Either<Failure, List<ConversationPreview>>> listConversations();
  Future<Either<Failure, List<ChatMessage>>> getConversationMessages(
    String conversationId,
  );
  Future<Either<Failure, Unit>> sendMessage({
    required String conversationId,
    required String text,
  });
}
