import 'package:flutter/material.dart';
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
  Widget buildView(BuildContext context) => Scaffold(
        appBar: StyledAppBar(
          context: context,
          backButton: BackArrowButton(),
          text: 'Peter H.',
          height: 92.h,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...msg.map(
                      (m) => Container(
                        alignment: m.sendByMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          top: 24.w,
                          bottom: 24.w,
                          right: m.sendByMe ? 32.w : 0.0,
                          left: m.sendByMe ? 0.0 : 32.w,
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 225.w),
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: m.sendByMe
                                ? Color(0xFFF8F7F7)
                                : Color(0xFFFFE3E3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(m.msg),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFBFAFA),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 9.0,
                  horizontal: 15.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 280.w,
                      child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Write a message...',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
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
                    TextButton(
                      onPressed: sendMsg,
                      child: Text(
                        'SEND',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
