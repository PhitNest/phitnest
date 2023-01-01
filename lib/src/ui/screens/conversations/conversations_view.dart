import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../entities/entities.dart';
import '../../theme.dart';
import '../../widgets/widgets.dart';

class LoadedView extends _BaseWidget {
  final List<Either<FriendEntity, Tuple2<ConversationEntity, MessageEntity>>>
      conversations;
  final void Function(FriendEntity friend) onTapFriend;
  final void Function(ConversationEntity conversation) onTapConversation;
  final String Function(ConversationEntity conversation) getChatName;

  LoadedView({
    required this.conversations,
    required this.onTapFriend,
    required this.onTapConversation,
    required this.getChatName,
    required super.onPressedFriends,
  }) : super(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: conversations.length,
            itemBuilder: (context, index) => conversations[index].fold(
              (friend) => _ConversationCard(
                message:
                    "You have just connected with ${friend.fullName}, say hello!",
                title: friend.fullName,
                onTap: () => onTapFriend(friend),
              ),
              (conversationMessagePair) => _ConversationCard(
                message: conversationMessagePair.value2.text,
                title: getChatName(conversationMessagePair.value1),
                onTap: () => onTapConversation(conversationMessagePair.value1),
              ),
            ),
          ),
        );
}

class LoadingView extends _BaseWidget {
  LoadingView({
    required super.onPressedFriends,
  }) : super(
          child: Column(
            children: [
              120.verticalSpace,
              CircularProgressIndicator(),
            ],
          ),
        );
}

class ErrorView extends _BaseWidget {
  final String errorMessage;
  final VoidCallback onPressedRetry;

  ErrorView({
    required this.errorMessage,
    required this.onPressedRetry,
    required super.onPressedFriends,
  }) : super(
          child: Column(
            children: [
              120.verticalSpace,
              Text(
                errorMessage,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.errorColor,
                ),
              ),
              20.verticalSpace,
              StyledButton(
                onPressed: onPressedRetry,
                child: Text('RETRY'),
              ),
            ],
          ),
        );
}

class NoConversationsView extends _BaseWidget {
  NoConversationsView({
    required super.onPressedFriends,
  }) : super(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              120.verticalSpace,
              Text(
                "You have no messages",
                style: theme.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              40.verticalSpace,
              Text(
                "Go explore and meet new friends!",
                style: theme.textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
}

class _BaseWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressedFriends;

  const _BaseWidget({
    required this.child,
    required this.onPressedFriends,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
          children: [
            40.verticalSpace,
            Container(
              width: 0.9.sw,
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onPressedFriends,
                child: Text(
                  'FRIENDS',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(child: child),
            StyledNavBar(page: NavbarPage.chat),
          ],
        ),
      );
}

class _ConversationCard extends StatelessWidget {
  final String message;
  final String title;
  final VoidCallback onTap;

  const _ConversationCard({
    required this.message,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: 14.h,
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 12.w),
          child: InkWell(
            onTap: onTap,
            highlightColor: Color(0xFFFFE3E3),
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: 0.9.sw,
              padding: EdgeInsets.symmetric(
                horizontal: 18.w,
                vertical: 16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall,
                  ),
                  8.44.verticalSpace,
                  Text(
                    message,
                    style: theme.textTheme.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
