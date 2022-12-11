import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackArrowButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackArrowButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(left: 12.w),
        alignment: Alignment.centerLeft,
        child: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: onPressed ?? () => Navigator.maybePop(context),
          icon: Image.asset(
            'assets/images/back_arrow.png',
            width: 40.w,
          ),
        ),
      );
}
