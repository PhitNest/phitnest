import 'package:flutter/cupertino.dart';

import '../state.dart';
import 'model/message.dart';

class MessageState extends ScreenState {
  TextEditingController messageController = TextEditingController();

  List<MessageModel> _message = [
    MessageModel(
      msg: 'Are you really sure?',
      sendByMe: true,
    ),
    MessageModel(
      msg:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      sendByMe: false,
    ),
    MessageModel(
      msg:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      sendByMe: true,
    ),
    MessageModel(
      msg:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      sendByMe: false,
    ),
    MessageModel(
      msg:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      sendByMe: false,
    ),
    MessageModel(
      msg:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      sendByMe: true,
    ),
    MessageModel(
      msg:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      sendByMe: false,
    ),
    MessageModel(
      msg:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      sendByMe: false,
    ),
    MessageModel(
      msg:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      sendByMe: true,
    ),
    MessageModel(
      msg:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      sendByMe: false,
    ),
  ];

  final String myCognitoId = "1";
  final DirectConversationEntity conversation = DirectConversationEntity(
    id: "1",
    userCognitoIds: ["1", "2"],
  );

  void sendMessage() {
    if (messageController.text.length > 0) {
      _message.insert(
        0,
        new MessageEntity(
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
      conversationId: "1",
      text: 'Are you really sure?',
      userCognitoId: "1",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      userCognitoId: "2",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "1",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "1",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      userCognitoId: "2",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "1",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "2",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Let’s go out to see the latest exhibition. I read that there are a lot of great things there. Sally recommends it too. Why don’t you bring your friend too? ',
      userCognitoId: "2",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
      conversationId: "1",
      text:
          'Because that’s not what I heard! I thought you were “taking off” to hang out with the new boy toy',
      userCognitoId: "2",
      createdAt: DateTime.now(),
    ),
    MessageEntity(
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
