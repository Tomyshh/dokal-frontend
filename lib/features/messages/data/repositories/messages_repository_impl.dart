import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/conversation_preview.dart';
import '../../domain/repositories/messages_repository.dart';
import '../datasources/messages_remote_data_source.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl({required this.remote});

  final MessagesRemoteDataSourceImpl remote;

  @override
  Future<Either<Failure, List<ConversationPreview>>> listConversations() async {
    try {
      final conversations = await remote.listConversationsAsync();
      return Right(conversations);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadConversations));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getConversationMessages(
    String conversationId,
  ) async {
    try {
      final messages = await remote.getMessagesAsync(conversationId);
      return Right(messages);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToLoadConversation));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    try {
      await remote.sendMessageAsync(
        conversationId: conversationId,
        content: text,
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToSendMessage));
    }
  }
}
