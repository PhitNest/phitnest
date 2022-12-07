import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/styled_app_bar.dart';
import '../../common/widgets.dart';
import '../view.dart';
import 'model/message.dart';

class MessageView extends ScreenView {
  final List<MessageModel> msg;
  final Function() sendMsg;
  final TextEditingController messageController;

  MessageView({
    required this.msg,
    required this.messageController,
    required this.sendMsg,
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
                    Flexible(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.05),
                            Colors.white,
                          ],
                          stops: [0, 0.008],
                          tileMode: TileMode.mirror,
                        ).createShader(bounds),
                        child: ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          padding: EdgeInsets.zero,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          physics: BouncingScrollPhysics(),
                          controller: scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) => messages[index],
                        ),
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
                                focusNode: messageFocus,
                                controller: messageController,
                                maxLines: 12,
                                minLines: 1,
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
