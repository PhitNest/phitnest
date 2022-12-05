import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class LoginView extends ScreenView {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onPressedSignIn;
  final VoidCallback onPressedForgotPassword;
  final VoidCallback onPressedRegister;
  final GlobalKey<FormState> formKey;
  final FormFieldValidator validateEmail;
  final FormFieldValidator validatePassword;
  final AutovalidateMode autovalidateMode;
  final ScrollController scrollController;
  final FocusNode focusPassword;
  final FocusNode focusEmail;
  final VoidCallback onTapEmail;
  final VoidCallback onTapPassword;

  LoginView({
    required this.emailController,
    required this.passwordController,
    required this.onPressedSignIn,
    required this.onPressedForgotPassword,
    required this.onPressedRegister,
    required this.autovalidateMode,
    required this.formKey,
    required this.validateEmail,
    required this.validatePassword,
    required this.scrollController,
    required this.focusPassword,
    required this.focusEmail,
    required this.onTapEmail,
    required this.onTapPassword,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          controller: scrollController,
          physics: NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: 1.sh,
            child: Column(
              children: [
                112.verticalSpace,
                LogoWidget(
                  width: 72.w,
                ),
                26.verticalSpace,
                Text(
                  'Phitnest is Better Together',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                54.verticalSpace,
                SizedBox(
                  width: 291.w,
                  child: Form(
                    key: formKey,
                    autovalidateMode: autovalidateMode,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40.h,
                          child: TextInputField(
                            hint: 'Email',
                            onTap: onTapEmail,
                            focusNode: focusEmail,
                            validator: validateEmail,
                            inputAction: TextInputAction.next,
                            controller: emailController,
                          ),
                        ),
                        16.verticalSpace,
                        SizedBox(
                          height: 40.h,
                          child: TextInputField(
                            hint: 'Password',
                            onTap: onTapPassword,
                            focusNode: focusPassword,
                            hide: true,
                            validator: validatePassword,
                            inputAction: TextInputAction.done,
                            controller: passwordController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                34.verticalSpace,
                StyledButton(
                  onPressed: onPressedSignIn,
                  child: Text('SIGN IN'),
                ),
                Expanded(child: Container()),
                TextButtonWidget(
                  onPressed: onPressedForgotPassword,
                  text: 'FORGOT PASSWORD?',
                ),
                TextButtonWidget(
                  onPressed: onPressedRegister,
                  text: 'REGISTER',
                ),
                37.verticalSpace
              ],
            ),
          ),
        ),
      );
}
