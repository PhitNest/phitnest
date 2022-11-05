import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class AfterForgotPasswordView extends ScreenView {
  final Function() onPressedSignIn;
  const AfterForgotPasswordView({required this.onPressedSignIn}) : super();

  @override
  Widget buildView(BuildContext context) => Container(
        width: double.infinity,
        child: Column(
          children: [
            200.verticalSpace,
            Text(
              'You’re almost there!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            40.verticalSpace,
            Text(
              'If we have an account for the\nemail you provided, we sent you\nan email to reset your password.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            40.verticalSpace,
            StyledButton(
                onPressed: onPressedSignIn,
                child: Text(
                  'SIGN IN',
                ))
          ],
        ),
      );
}
