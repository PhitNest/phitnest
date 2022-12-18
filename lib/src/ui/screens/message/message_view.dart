import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';
import 'widgets/widgets.dart';

class MessageView extends ScreenView {
  final VoidCallback onPressSend;
  final TextEditingController messageController;
  final String name;
  final bool loading;
  final List<MessageCard>? messages;
  final String? errorMessage;
  final VoidCallback onPressedRetry;
  final ScrollController scrollController;
  final FocusNode messageFocus;

  MessageView({
    required this.messageController,
    required this.onPressSend,
    required this.name,
    required this.loading,
    required this.messages,
    required this.errorMessage,
    required this.onPressedRetry,
    required this.scrollController,
    required this.messageFocus,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    messages != null
                        ? messages!.length > 0
                            ? Flexible(
                                child: ListView.builder(
                                  controller: scrollController,
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  reverse: true,
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: messages!.length,
                                  itemBuilder: (context, index) =>
                                      messages![index],
                                ),
                              )
                            : Expanded(
                                child: Center(
                                  child: Text(
                                    'Say Hello!',
                                    style: theme.textTheme.headlineLarge,
                                  ),
                                ),
                              )
                        : Expanded(
                            child: loading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        errorMessage ?? "",
                                        style: theme.textTheme.labelMedium!
                                            .copyWith(
                                          color: theme.colorScheme.error,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      StyledButton(
                                        onPressed: onPressedRetry,
                                        child: Text('RETRY'),
                                      ),
                                    ],
                                  ),
                          ),
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
                                onFieldSubmitted: (value) => onPressSend(),
                                focusNode: messageFocus,
                                decoration: InputDecoration(
                                  hintText: 'Write a message...',
                                  hintStyle:
                                      Theme.of(context).textTheme.bodySmall,
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
                              onPressed: onPressSend,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
