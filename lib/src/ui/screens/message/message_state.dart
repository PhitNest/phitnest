import 'package:flutter/cupertino.dart';

import '../../../entities/entities.dart';
import '../state.dart';

class MessageState extends ScreenState {
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  late final FocusNode messageFocus = FocusNode()
    ..addListener(
      () => scrollController.animateTo(
        0,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeInOut,
      ),
    );

  final List<PublicUserEntity> users = [
    new PublicUserEntity(
      id: "1",
      firstName: "me",
      lastName: "jones",
      cognitoId: "1",
      gymId: "1",
    ),
    new PublicUserEntity(
      id: "2",
      firstName: "Priscilla",
      lastName: "H.",
      cognitoId: "2",
      gymId: "1",
    ),
  ];

  final String myCognitoId = "1";
  final ConversationEntity conversation = ConversationEntity(
    id: "1",
    users: [],
  );

  void sendMessage() {
    if (messageController.text.length > 0) {
      _message.insert(
        0,
        new MessageEntity(
          id: _message.length.toString(),
          conversationId: conversation.id,
          text: messageController.text,
          userCognitoId: myCognitoId,
          createdAt: DateTime.now(),
        ),
      );
      messageController.clear();
      rebuildView();
    }
    messageFocus.unfocus();
  }

  final List<MessageEntity> _message = [
    MessageEntity(
      id: "1",
      conversationId: "1",
      text: 'Are you really sure?',
      userCognitoId: "1",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      id: "2",
      conversationId: "1",
      text:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      userCognitoId: "2",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      id: "3",
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "1",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      id: "4",
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "1",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      id: "5",
      conversationId: "1",
      text:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      userCognitoId: "2",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      id: "6",
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "1",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      id: "7",
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "2",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      id: "8",
      conversationId: "1",
      text:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      userCognitoId: "2",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      id: "9",
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "2",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      id: "10",
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "1",
      createdAt: DateTime.now(),
    ),
  ];

  List<MessageEntity> get message => _message;

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
