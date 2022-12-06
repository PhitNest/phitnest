import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_mobile/src/ui/widgets/back_arrow_button.dart';

import '../../theme.dart';
import '../view.dart';
import 'widgets/widgets.dart';

class MessageView extends ScreenView {
  final List<MessageCard> messages;
  final VoidCallback onPressSend;
  final TextEditingController messageController;
  final ScrollController scrollController;
  final String name;
  final FocusNode messageFocus;

  MessageView({
    required this.messages,
    required this.messageController,
    required this.onPressSend,
    required this.scrollController,
    required this.name,
    required this.messageFocus,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            40.verticalSpace,
            Stack(
              children: [
                BackArrowButton(),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10.h),
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
                        stops: [0, 0.01],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds),
                      child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        padding: EdgeInsets.zero,
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
                      padding: EdgeInsets.symmetric(
                        vertical: 9.h,
                        horizontal: 14.w,
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
      );
}
