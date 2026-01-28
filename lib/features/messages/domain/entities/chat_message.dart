import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage({required this.fromMe, required this.text});

  final bool fromMe;
  final String text;

  @override
  List<Object?> get props => [fromMe, text];
}
