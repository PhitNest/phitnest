import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ConfirmEmailView extends ScreenView {
  final Function(String code) onCompletedVerification;
  final Function() onPressedNext;

  const ConfirmEmailView(
      {required this.onCompletedVerification, required this.onPressedNext})
      : super();

  @override
  Widget buildView(BuildContext context) => Column(children: [
        18.verticalSpace,
        Text("Please confirm\nthat it's you.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge),
        40.verticalSpace,
        Text(
            "Check your email for a verification\ncode from us and enter it below",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge),
        60.verticalSpace,
        VerificationCode(
          underlineColor: Colors.black,
          onCompleted: onCompletedVerification,
          length: 6,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          itemSize: 45,
          onEditing: (value) {},
        ),
        180.verticalSpace,
        StyledButton(
          child: Text("NEXT"),
          onPressed: onPressedNext,
        )
      ]);
}
