import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class AfterForgotPasswordView extends ScreenView {
  final VoidCallback onPressedSignIn;

  const AfterForgotPasswordView({
    required this.onPressedSignIn,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Column(
            children: [
              double.infinity.horizontalSpace,
              200.verticalSpace,
              Text(
                'You’re almost there!',
                style: theme.textTheme.headlineLarge,
              ),
              40.verticalSpace,
              Text(
                'If we have an account for the\nemail you provided, we sent you\nan email to reset your password.',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge,
              ),
              40.verticalSpace,
              StyledButton(
                onPressed: onPressedSignIn,
                child: Text(
                  'SIGN IN',
                ),
              )
            ],
          ),
        ),
      );
}
