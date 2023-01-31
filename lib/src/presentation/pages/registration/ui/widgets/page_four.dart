import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/theme.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../widgets/styled/styled.dart';

class PageFourError extends _PageFourBase {
  final String error;

  PageFourError({
    Key? key,
    required GymEntity gym,
    required VoidCallback onPressedYes,
    required VoidCallback onPressedNo,
    required this.error,
  }) : super(
          key: key,
          gym: gym,
          onPressedYes: onPressedYes,
          onPressedNo: onPressedNo,
          buttonText: "RETRY",
          child: Column(
            children: [
              20.verticalSpace,
              Text(
                error,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.errorColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
}

class PageFour extends _PageFourBase {
  PageFour({
    Key? key,
    required GymEntity gym,
    required VoidCallback onPressedYes,
    required VoidCallback onPressedNo,
  }) : super(
          key: key,
          gym: gym,
          onPressedYes: onPressedYes,
          onPressedNo: onPressedNo,
          buttonText: "YES",
        );
}

class _PageFourBase extends StatelessWidget {
  final GymEntity gym;
  final VoidCallback onPressedYes;
  final VoidCallback onPressedNo;
  final Widget? child;
  final String buttonText;

  const _PageFourBase({
    Key? key,
    required this.gym,
    required this.onPressedYes,
    required this.onPressedNo,
    required this.buttonText,
    this.child,
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
            text: buttonText,
          ),
          child ?? Container(),
          Spacer(),
          StyledUnderlinedTextButton(
            text: "NO, IT'S NOT",
            onPressed: onPressedNo,
          ),
          32.verticalSpace,
        ],
      );
}
