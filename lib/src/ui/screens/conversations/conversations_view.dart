import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view.dart';
import 'models/conversation.dart';
import 'widgets/conversation_card.dart';

class ConversationsView extends ScreenView {
  final List<ConversationModel> conversations;
  final void Function(int conversationIndex) onDownTapMessage;
  final void Function(int conversationIndex) onUpTapMessage;
  final VoidCallback onClickFriends;

  ConversationsView({
    required this.conversations,
    required this.onDownTapMessage,
    required this.onUpTapMessage,
    required this.onClickFriends,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            73.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onClickFriends,
                  child: Text(
                    'FRIENDS',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                ),
                32.horizontalSpace,
              ],
            ),
            Expanded(
              child: ListView(
                children: conversations
                    .asMap()
                    .entries
                    .map(
                      (entry) => ConversationCard(
                        conversation: entry.value,
                        onDownTap: () => onDownTapMessage(entry.key),
                        onUpTap: () => onUpTapMessage(entry.key),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
}
