import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../entities/entities.dart';
import '../../theme.dart';
import '../../widgets/widgets.dart';

class MessageView extends _BaseWidget {
  final List<MessageEntity> messages;
  final bool Function(MessageEntity message) isMe;
  final ScrollController scrollController;

  MessageView({
    required this.messages,
    required this.isMe,
    required this.scrollController,
    required super.onPressedSend,
    required super.messageController,
    required super.messageFocus,
    required super.name,
  }) : super(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  reverse: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: ClampingScrollPhysics(),
                  itemCount: messages.length,
                  itemBuilder: (context, index) => _MessageCard(
                    message: messages[index].text,
                    sentByMe: isMe(messages[index]),
                  ),
                ),
              ),
            ],
          ),
        );
}

class ErrorView extends _BaseWidget {
  final VoidCallback onPressedRetry;
  final String message;

  ErrorView({
    required this.onPressedRetry,
    required this.message,
    required super.onPressedSend,
    required super.messageController,
    required super.messageFocus,
    required super.name,
  }) : super(
          child: Column(
            children: [
              120.verticalSpace,
              Text(
                message,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.errorColor,
                ),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              StyledButton(
                child: Text('RETRY'),
                onPressed: onPressedRetry,
              ),
            ],
          ),
        );
}

class LoadingConversationView extends _BaseWidget {
  LoadingConversationView({
    required super.onPressedSend,
    required super.messageController,
    required super.messageFocus,
    required super.name,
  }) : super(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
}

class NewFriendView extends _BaseWidget {
  NewFriendView({
    required super.name,
    required super.onPressedSend,
    required super.messageController,
    required super.messageFocus,
  }) : super(
          child: Column(
            children: [
              120.verticalSpace,
              Text(
                'Say hello!',
                style: theme.textTheme.headlineLarge,
              ),
              Spacer(),
            ],
          ),
        );
}

class InitialView extends StatelessWidget {
  const InitialView() : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
}

abstract class _BaseWidget extends StatelessWidget {
  final VoidCallback onPressedSend;
  final TextEditingController messageController;
  final String name;
  final FocusNode messageFocus;
  final Widget child;

  const _BaseWidget({
    required this.onPressedSend,
    required this.messageController,
    required this.name,
    required this.messageFocus,
    required this.child,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
          children: [
            40.verticalSpace,
            Stack(
              children: [
                BackArrowButton(),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    name,
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
              ],
            ),
            Expanded(child: child),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF8F7F7),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 9.h,
                  bottom: 18.h,
                  left: 14.w,
                  right: 14.w,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        maxLines: 12,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (value) => onPressedSend(),
                        focusNode: messageFocus,
                        decoration: InputDecoration(
                          hintText: 'Write a message...',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.w),
                            borderSide: BorderSide(
                              color: Color(0xFFEAE7E7),
                              width: 1.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.w),
                            borderSide: BorderSide(
                              color: Color(0xFFEAE7E7),
                              width: 1.w,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 7.5.w,
                          ),
                          border: InputBorder.none,
                          fillColor: Color(0xFFFFFFFF),
                          filled: true,
                        ),
                      ),
                    ),
                    14.horizontalSpace,
                    TextButton(
                      onPressed: onPressedSend,
                      child: Text(
                        'SEND',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      );
}

class _MessageCard extends StatelessWidget {
  final bool sentByMe;
  final String message;

  const _MessageCard({
    required this.sentByMe,
    required this.message,
  }) : super();

  @override
  Widget build(BuildContext context) => Container(
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.only(
          top: 12.w,
          bottom: 12.w,
          right: sentByMe ? 32.w : 0.0,
          left: sentByMe ? 0.0 : 32.w,
        ),
        child: Container(
          constraints: BoxConstraints(maxWidth: 225.w),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: sentByMe ? Color(0xFFF8F7F7) : Color(0xFFFFE3E3),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            message,
          ),
        ),
      );
}
