import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';
import '../widgets.dart';

class OnBoardingIntro extends StatelessWidget {
  final VoidCallback onPressedButton;

  const OnBoardingIntro({
    Key? key,
    required this.onPressedButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 120.h,
          ),
          Text(
            "It takes a village\nto live a healthy life",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          40.verticalSpace,
          Text(
            "Meet people at your fitness club.\nAchieve your goals together.\nLive a healthy life!",
            style: theme.textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          Spacer(),
          StyledButton(
            onPressed: onPressedButton,
            text: "LET\'S GET STARTED",
          ),
          167.verticalSpace,
        ],
      );
}
