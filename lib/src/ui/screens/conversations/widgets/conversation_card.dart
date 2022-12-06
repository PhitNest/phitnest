import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class ConversationCard extends StatelessWidget {
  final String message;
  final String title;
  final void Function(DismissDirection direction) onDismissed;
  final VoidCallback onTap;

  const ConversationCard({
    required this.message,
    required this.title,
    required this.onDismissed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: 14.h,
        ),
        child: Dismissible(
          dragStartBehavior: DragStartBehavior.down,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 12.w),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          key: UniqueKey(),
          onDismissed: onDismissed,
          direction: DismissDirection.startToEnd,
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
