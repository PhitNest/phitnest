import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/conversation.dart';

class ConversationCard extends StatelessWidget {
  final ConversationModel conversation;
  final Function() onDownTap;
  final Function() onUpTap;

  const ConversationCard({
    required this.conversation,
    required this.onDownTap,
    required this.onUpTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => onDownTap(),
        onTapCancel: onUpTap,
        onTapUp: (details) => onUpTap(),
        child: Container(
          width: 343.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color:
                conversation.selected ? Color(0xFFFFE3E3) : Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.name,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 18.sp),
                ),
                8.44.verticalSpace,
                Text(
                  conversation.recentMessage,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      );
}
