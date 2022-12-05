import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';
import 'widgets/conversation_card.dart';

class ConversationsView extends ScreenView {
  final List<ConversationCard> conversations;
  final VoidCallback onClickFriends;
  final VoidCallback onTapLogoButton;

  ConversationsView({
    required this.conversations,
    required this.onClickFriends,
    required this.onTapLogoButton,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Column(
            children: [
              40.verticalSpace,
              Container(
                width: 0.9.sw,
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onClickFriends,
                  child: Text(
                    'FRIENDS',
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: conversations.length,
                  itemBuilder: (context, index) => conversations[index],
                ),
              ),
              StyledNavBar(
                pageIndex: 2,
                onTapDownLogo: onTapLogoButton,
                navigationEnabled: true,
              ),
            ],
          ),
        ),
      );
}
