import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class RegisterPageTwoView extends ScreenView {
  final VoidCallback onPressedNext;
  final bool keyboardVisible;

  RegisterPageTwoView({
    required this.keyboardVisible,
    required this.onPressedNext,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            28.verticalSpace,
            Text(
              'Register',
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            35.verticalSpace,
            SizedBox(
              width: 291.w,
              child: Form(
                child: Column(
                  children: [
                    SizedBox(
                      height: 34.h,
                      child: TextInputField(
                        hint: 'Email',
                        inputAction: TextInputAction.next,
                      ),
                    ),
                    16.verticalSpace,
                    SizedBox(
                      height: 34.h,
                      child: TextInputField(
                        hint: 'Password',
                      ),
                    ),
                    16.verticalSpace,
                    SizedBox(
                        height: 34.h,
                        child: TextInputField(
                          hint: "Confirm Password",
                        ))
                  ],
                ),
              ),
            ),
            keyboardVisible ? 65.verticalSpace : Expanded(child: Container()),
            StyledButton(
              onPressed: onPressedNext,
              child: Text('NEXT'),
            ),
            keyboardVisible ? Container() : 116.verticalSpace,
          ],
        ),
      );
}
