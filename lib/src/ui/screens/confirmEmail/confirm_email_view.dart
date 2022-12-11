import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class ConfirmEmailView extends ScreenView {
  final void Function(String code) onCompletedVerification;
  final VoidCallback onPressedResend;

  const ConfirmEmailView({
    required this.onCompletedVerification,
    required this.onPressedResend,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: SizedBox(
              height: 1.sh,
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
                    style: theme.textTheme.headlineLarge,
                  ),
                  40.verticalSpace,
                  Text(
                    "Check your email for a verification\ncode from us and enter it below",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge,
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
                  Expanded(child: Container()),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: max(
                        MediaQuery.of(context).viewInsets.bottom + 20.h,
                        100.h,
                      ),
                    ),
                    child: StyledButton(
                      child: Text("RESEND CODE"),
                      onPressed: onPressedResend,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
