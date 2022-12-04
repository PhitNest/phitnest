import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view.dart';
import 'models/conversation.dart';
import 'widgets/conversation_card.dart';

class ConversationsView extends ScreenView {
  final List<ConversationModel> conversations;
  final Function(int conversationIndex) onDownTapMessage;
  final Function(int conversationIndex) onUpTapMessage;
  final Function() onClickFriends;

  ConversationsView({
    required this.conversations,
    required this.onDownTapMessage,
    required this.onUpTapMessage,
    required this.onClickFriends,
  });

  @override
  int get navbarIndex => 2;

  @override
  bool showAppBar(BuildContext context) => false;

  @override
  Widget build(BuildContext context) => Column(
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
      );
}
