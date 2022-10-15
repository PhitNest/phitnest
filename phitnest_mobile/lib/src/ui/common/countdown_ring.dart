import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountdownRing extends StatelessWidget {
  final int countdownNum;

  const CountdownRing({Key? key, this.countdownNum = 3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.w,
      height: 240.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xffE9E8E8),
          width: 6.0,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xffE9E8E8),
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
                color: Color(0xffE9E8E8),
                width: 6.0,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xffE9E8E8),
                ),
              ),
              child: Center(
                child: Text(
                  '$countdownNum',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: 128.sp,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
