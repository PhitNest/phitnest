import 'package:flutter/material.dart';
import '../../../../constants/constants.dart';

import '../../../common/textStyles/text_styles.dart';
import 'message_bubble.dart';

/// Sent message bubble
class SentMessageBubble extends MessageBubble {
  EdgeInsets get padding => EdgeInsets.fromLTRB(45.0, 10.0, 10.0, 10.0);
  Color get bubbleColor => kColorPrimary;
  Color get textColor => Colors.white;

  SentMessageBubble({Key? key, required String message})
      : super(key: key, message: message);

  @override
  Widget build(BuildContext context) => Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: borderRadius,
                  bottomLeft: borderRadius,
                  topRight: borderRadius,
                ),
              ),
              child: Text(
                message,
                style:
                    BodyTextStyle(color: Colors.white, size: TextSize.MEDIUM),
              ),
            ),
          ),
          CustomPaint(painter: tip),
        ],
      ));
}
