import 'package:flutter/material.dart';
import 'package:phitnest/constants/constants.dart';
import 'package:validation/validation.dart';

import '../../common/textStyles/text_styles.dart';
import '../../common/widgets/widgets.dart';
import '../screen_view.dart';
import 'chatBubble/message_bubble.dart';

class ChatMessagingView extends ScreenView {
  final String fullName;
  final List<MessageBubble> messageBubbles;
  final TextEditingController messageController;
  final Function(String? message) onSendMessage;
  final ScrollController scrollController;
  final FocusNode focusNode;

  const ChatMessagingView({
    Key? key,
    required this.messageController,
    required this.fullName,
    required this.focusNode,
    required this.scrollController,
    required this.messageBubbles,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: BackButtonAppBar(
        color: Colors.grey.shade300,
        content: Text(
          fullName,
          style: HeadingTextStyle(size: TextSize.LARGE, color: Colors.black),
        ),
      ),
      body: Column(children: [
        Expanded(
            child: SingleChildScrollView(
                reverse: true,
                controller: scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: messageBubbles.reversed.toList(),
                ))),
        Row(children: [
          Expanded(
              child: TextInputFormField(
            key: Key('textInput'),
            focusNode: focusNode,
            hint: 'Send message...',
            validator: validateMessage,
            inputType: TextInputType.text,
            controller: messageController,
            onSubmit: onSendMessage,
            inputAction: TextInputAction.send,
          )),
          Padding(
              padding: EdgeInsets.only(right: 6.0),
              child: FloatingActionButton(
                  mini: true,
                  backgroundColor: kColorPrimary,
                  child: Icon(Icons.send),
                  onPressed: () => onSendMessage(messageController.text)))
        ])
      ]));
}
