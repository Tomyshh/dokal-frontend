import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/chat_message.dart';
import '../repositories/messages_repository.dart';

class GetConversationMessages {
  GetConversationMessages(this.repo);

  final MessagesRepository repo;

  Future<Either<Failure, List<ChatMessage>>> call(String conversationId) =>
      repo.getConversationMessages(conversationId);
}

