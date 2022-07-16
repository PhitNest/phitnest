import 'package:flutter/material.dart';

import '../../../common/textStyles/text_styles.dart';
import 'message_bubble.dart';

/// Received message bubble
class ReceivedMessageBubble extends MessageBubble {
  EdgeInsets get padding => EdgeInsets.fromLTRB(10.0, 10.0, 45.0, 10.0);
  Color get bubbleColor => Colors.grey.shade300;
  Color get textColor => Colors.black;

  ReceivedMessageBubble({Key? key, required String message})
      : super(key: key, message: message);

  @override
  Widget build(BuildContext context) => Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomPaint(
            painter: tip,
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topRight: borderRadius,
                  topLeft: borderRadius,
                  bottomRight: borderRadius,
                ),
              ),
              child: Text(
                message,
                style: BodyTextStyle(color: textColor, size: TextSize.MEDIUM),
              ),
            ),
          ),
        ],
      ));
}
