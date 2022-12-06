import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageCard extends StatelessWidget {
  final bool sentByMe;
  final String message;

  const MessageCard({
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
