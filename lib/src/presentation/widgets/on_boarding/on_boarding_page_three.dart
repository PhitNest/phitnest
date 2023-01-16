import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';
import '../../widgets/widgets.dart';

class OnBoardingPageThree extends StatelessWidget {
  final VoidCallback onPressedButton;
  final String firstName;

  const OnBoardingPageThree({
    Key? key,
    required this.onPressedButton,
    required this.firstName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            "Let's get ready\nto meet people,\n$firstName.",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          40.verticalSpace,
          Text(
            "Do you belong to a fitness club?",
            style: theme.textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          StyledButton(
            onPressed: onPressedButton,
            text: "NEXT",
          ),
        ],
      );
}
