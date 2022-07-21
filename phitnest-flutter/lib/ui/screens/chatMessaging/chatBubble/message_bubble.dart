// Sent message bubble
import 'package:flutter/material.dart';

import 'bubble_tip.dart';

export 'received_message_bubble.dart';
export 'sent_message_bubble.dart';

abstract class MessageBubble extends StatelessWidget {
  Radius get borderRadius => Radius.circular(19.0);
  EdgeInsets get padding;
  Color get bubbleColor;
  Color get textColor;

  late final BubbleTip tip;
  final String message;

  MessageBubble({Key? key, required this.message}) : super(key: key) {
    tip = BubbleTip(bubbleColor);
  }
}
