import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/messages_repository.dart';

class SendMessage {
  SendMessage(this.repo);

  final MessagesRepository repo;

  Future<Either<Failure, Unit>> call({
    required String conversationId,
    required String text,
  }) =>
      repo.sendMessage(conversationId: conversationId, text: text);
}

