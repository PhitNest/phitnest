import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class ForgotPasswordView extends ScreenView {
  final TextEditingController emailAddressController;
  final VoidCallback onPressedsubmit;
  final ScrollController scrollController;
  final FocusNode emailFocus;
  final VoidCallback onTapEmail;

  const ForgotPasswordView({
    required this.emailAddressController,
    required this.onPressedsubmit,
    required this.scrollController,
    required this.emailFocus,
    required this.onTapEmail,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              controller: scrollController,
              child: SizedBox(
                height: 1.sh,
                child: Column(
                  children: [
                    40.verticalSpace,
                    BackArrowButton(),
                    110.verticalSpace,
                    Text(
                      'Forgot the password?',
                      style: theme.textTheme.headlineLarge,
                    ),
                    42.verticalSpace,
                    Text(
                      'We’ll send you an email to reset\nyour password.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge,
                    ),
                    56.verticalSpace,
                    SizedBox(
                      height: 34.h,
                      width: 291.w,
                      child: TextInputField(
                        focusNode: emailFocus,
                        controller: emailAddressController,
                        onTap: onTapEmail,
                        hint: 'Email',
                      ),
                    ),
                    30.verticalSpace,
                    StyledButton(
                      onPressed: onPressedsubmit,
                      child: Text(
                        'SUBMIT',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
