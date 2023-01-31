import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/assets.dart';

class StyledBackButton extends StatelessWidget {
  const StyledBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(
          left: 8.w,
        ),
        alignment: Alignment.centerLeft,
        width: double.infinity,
        child: IconButton(
          splashRadius: 28,
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
