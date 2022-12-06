import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';

class CountdownRing extends StatelessWidget {
  final int countdownNum;
  final bool dark;

  Color get color => dark ? Color(0xffE9E8E8) : Colors.white;

  const CountdownRing({
    Key? key,
    required this.countdownNum,
    this.dark = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.w,
      height: 240.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 6.0,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: 150.w,
            height: 159.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 6.0,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                ),
              ),
              child: Center(
                child: Text(
                  countdownNum.toString(),
                  style: theme.textTheme.labelLarge!.copyWith(
                      fontSize: 128.sp,
                      color: dark ? Colors.black : Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
