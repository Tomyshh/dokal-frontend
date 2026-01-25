import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/conversation_preview.dart';
import '../repositories/messages_repository.dart';

class GetConversations {
  GetConversations(this.repo);

  final MessagesRepository repo;

  Future<Either<Failure, List<ConversationPreview>>> call() =>
      repo.listConversations();
}

