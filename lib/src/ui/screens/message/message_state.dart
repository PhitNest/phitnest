import '../state.dart';
import 'model/message.dart';

class MessageState extends ScreenState {
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

  List<MessageModel> get message => _message;
}
