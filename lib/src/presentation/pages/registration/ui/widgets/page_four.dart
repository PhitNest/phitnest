import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/theme.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../widgets/styled/styled.dart';

class PageFour extends StatelessWidget {
  final GymEntity gym;
  final VoidCallback onPressedYes;
  final VoidCallback onPressedNo;

  const PageFour({
    Key? key,
    required this.gym,
    required this.onPressedYes,
    required this.onPressedNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          120.verticalSpace,
          Text(
            "Is this your\nfitness club?",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          40.verticalSpace,
          Text(
            gym.name,
            style: theme.textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          Text(
            gym.address.toString(),
            style: theme.textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          134.verticalSpace,
          StyledButton(
            onPressed: onPressedYes,
            text: "YES",
          ),
          Spacer(),
          StyledUnderlinedTextButton(
            text: "NO, IT'S NOT",
            onPressed: onPressedNo,
          ),
          32.verticalSpace,
        ],
      );
}
