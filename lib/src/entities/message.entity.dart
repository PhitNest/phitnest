import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String text;
  final String conversationId;
  final String userCognitoId;
  final DateTime createdAt;

  const MessageEntity({
    required this.text,
    required this.conversationId,
    required this.userCognitoId,
    required this.createdAt,
  }) : super();

  @override
  List<Object?> get props => [text, conversationId, userCognitoId, createdAt];
}
