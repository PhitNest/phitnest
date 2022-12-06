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
  final DirectConversationEntity conversation = DirectConversationEntity(
    id: "1",
    userCognitoIds: ["1", "2"],
  );

  void sendMessage() {
    _message.insert(
      0,
      new MessageEntity(
          conversationId: conversation.id,
          text: messageController.text,
          userCognitoId: myCognitoId),
    );
    messageController.clear();
    messageFocus.unfocus();
    rebuildView();
  }

  final List<MessageEntity> _message = [
    MessageEntity(
      conversationId: "1",
      text: 'Are you really sure?',
      userCognitoId: "1",
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      userCognitoId: "2",
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "1",
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "1",
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      userCognitoId: "2",
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "1",
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "2",
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      userCognitoId: "2",
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "2",
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "1",
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
