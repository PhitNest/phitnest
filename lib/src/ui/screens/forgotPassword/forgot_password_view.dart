import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ForgotPasswordView extends ScreenView {
  final TextEditingController emailAddressController;
  final Function() onPressedsubmit;

  const ForgotPasswordView(
      {required this.emailAddressController, required this.onPressedsubmit})
      : super();

  @override
  String? get appBarText => "";

  @override
  Widget buildView(BuildContext context) => Container(
        width: double.infinity,
        child: Column(
          children: [
            110.verticalSpace,
            Text(
              'Forgot the password?',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            42.verticalSpace,
            Text(
              'We’ll send you an email to reset\nyour password.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            56.verticalSpace,
            SizedBox(
              height: 34.h,
              width: 291.w,
              child: TextInputField(
                controller: emailAddressController,
                hint: 'Email',
              ),
            ),
            30.verticalSpace,
            StyledButton(
                onPressed: onPressedsubmit,
                child: Text(
                  'SUBMIT',
                ))
          ],
        ),
      );
}
