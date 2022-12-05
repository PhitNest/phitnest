import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class ConversationCard extends StatelessWidget {
  final String message;
  final bool selected;
  final String title;
  final void Function(DismissDirection direction) onDismissed;
  final VoidCallback onDeselect;
  final VoidCallback onSelect;

  const ConversationCard({
    required this.message,
    required this.title,
    required this.selected,
    required this.onDismissed,
    required this.onDeselect,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: 14.h,
        ),
        child: Dismissible(
          behavior: HitTestBehavior.translucent,
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
          child: GestureDetector(
            onTapDown: (details) => onSelect(),
            child: Container(
              width: 343.w,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: selected ? Color(0xFFFFE3E3) : Colors.transparent,
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
