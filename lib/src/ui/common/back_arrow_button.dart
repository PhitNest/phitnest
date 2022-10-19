import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets.dart';

class BackArrowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      alignment: Alignment.centerLeft,
      width: 1.sw,
      margin: EdgeInsets.only(left: 16.w),
      child: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: Arrow(
            width: 40.w,
            height: 10.h,
            left: true,
            color: Theme.of(context).colorScheme.primary,
          )));
}
