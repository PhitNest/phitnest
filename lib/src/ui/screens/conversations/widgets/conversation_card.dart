import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConversationCard extends StatelessWidget {
  final String message;
  final String title;
  final bool selected;
  final void Function(DismissDirection direction) onDismissed;

  const ConversationCard({
    required this.message,
    required this.title,
    required this.selected,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) => Dismissible(
        key: UniqueKey(),
        onDismissed: onDismissed,
        child: Container(
          width: 343.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: selected ? Color(0xFFFFE3E3) : Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                8.44.verticalSpace,
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      );
}
