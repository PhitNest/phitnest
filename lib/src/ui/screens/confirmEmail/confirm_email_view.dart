import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

import '../../widgets/widgets.dart';
import '../view.dart';

class ConfirmEmailView extends ScreenView {
  final void Function(String code) onCompletedVerification;
  final VoidCallback onPressedNext;

  const ConfirmEmailView({
    required this.onCompletedVerification,
    required this.onPressedNext,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              40.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: BackArrowButton(),
              ),
              30.verticalSpace,
              Text(
                "Please confirm\nthat it's you.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              40.verticalSpace,
              Text(
                "Check your email for a verification\ncode from us and enter it below",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              60.verticalSpace,
              VerificationCode(
                underlineColor: Colors.black,
                onCompleted: onCompletedVerification,
                onEditing: (_) {},
                length: 6,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                itemSize: 40.w,
              ),
              180.verticalSpace,
              StyledButton(
                child: Text("NEXT"),
                onPressed: onPressedNext,
              )
            ],
          ),
        ),
      );
}
