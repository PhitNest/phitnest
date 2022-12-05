import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String text;
  final String conversationId;
  final String userCognitoId;

  const MessageEntity({
    required this.text,
    required this.conversationId,
    required this.userCognitoId,
  }) : super();

  @override
  List<Object?> get props => [text, conversationId, userCognitoId];
}
