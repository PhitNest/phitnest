import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackArrowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(left: 8.w),
        alignment: AlignmentDirectional.bottomCenter,
        height: double.infinity,
        child: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.maybePop(context),
          icon: Image.asset(
            'assets/images/back_arrow.png',
            width: 40.w,
          ),
        ),
      );
}
