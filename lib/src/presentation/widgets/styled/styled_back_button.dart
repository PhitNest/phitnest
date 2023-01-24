import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/assets.dart';

class StyledBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const StyledBackButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 28,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Image.asset(
        Assets.backButton.path,
        width: 32.w,
      ),
      onPressed: onPressed,
    );
  }
}
