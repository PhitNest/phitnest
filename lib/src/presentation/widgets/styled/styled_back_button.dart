import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/constants.dart';

class StyledBackButton extends StatelessWidget {
  const StyledBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: 10.h,
          left: 8.w,
        ),
        alignment: Alignment.centerLeft,
        width: double.infinity,
        child: IconButton(
          splashRadius: 28.w,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Image.asset(
            Assets.backButton.path,
            width: 32.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      );
}
