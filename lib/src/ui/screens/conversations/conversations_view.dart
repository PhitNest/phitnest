import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view.dart';
import 'widgets/conversation_card.dart';

class ConversationsView extends ScreenView {
  final List<ConversationCard> conversations;
  final VoidCallback onClickFriends;

  ConversationsView({
    required this.conversations,
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
                        ),
                  ),
                ),
                32.horizontalSpace,
              ],
            ),
            Expanded(
              child: ListView(
                children: conversations,
              ),
            ),
          ],
        ),
      );
}
