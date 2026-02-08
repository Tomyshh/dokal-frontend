import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.fromMe,
    required this.text,
    required this.createdAt,
    this.messageType = 'text',
  });

  final String id;
  final bool fromMe;
  final String text;
  final String createdAt;
  final String messageType;

  @override
  List<Object?> get props => [id, fromMe, text, createdAt, messageType];
}
