import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class RegisterPageTwoView extends ScreenView {
  final VoidCallback onPressedNext;
  final GlobalKey<FormState> formKey;
  final FormFieldValidator validateEmail;
  final FormFieldValidator validatePassword;
  final FormFieldValidator validateConfirmPassword;
  final AutovalidateMode autovalidateMode;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onTapEmail;
  final VoidCallback onTapPassword;
  final VoidCallback onTapConfirmPassword;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final FocusNode confirmPasswordFocus;
  final ScrollController scrollController;
  final VoidCallback onPressedBack;
  final String? errorMessage;

  RegisterPageTwoView({
    required this.onPressedNext,
    required this.formKey,
    required this.validateEmail,
    required this.validatePassword,
    required this.validateConfirmPassword,
    required this.autovalidateMode,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onTapEmail,
    required this.onTapPassword,
    required this.onTapConfirmPassword,
    required this.errorMessage,
    required this.emailFocus,
    required this.passwordFocus,
    required this.confirmPasswordFocus,
    required this.scrollController,
    required this.onPressedBack,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Column(
            children: [
              40.verticalSpace,
              BackArrowButton(
                onPressed: onPressedBack,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
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
                          key: formKey,
                          autovalidateMode: autovalidateMode,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 34.h,
                                child: TextInputField(
                                  hint: 'Email',
                                  onTap: onTapEmail,
                                  validator: validateEmail,
                                  controller: emailController,
                                  focusNode: emailFocus,
                                  inputAction: TextInputAction.next,
                                ),
                              ),
                              16.verticalSpace,
                              SizedBox(
                                height: 34.h,
                                child: TextInputField(
                                  hint: 'Password',
                                  validator: validatePassword,
                                  onTap: onTapPassword,
                                  controller: passwordController,
                                  focusNode: passwordFocus,
                                  hide: true,
                                  inputAction: TextInputAction.next,
                                ),
                              ),
                              16.verticalSpace,
                              SizedBox(
                                height: 34.h,
                                child: TextInputField(
                                  hint: "Confirm Password",
                                  validator: validateConfirmPassword,
                                  onTap: onTapConfirmPassword,
                                  controller: confirmPasswordController,
                                  focusNode: confirmPasswordFocus,
                                  hide: true,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: errorMessage != null,
                        child: Container(
                          padding: EdgeInsets.only(top: 40.h),
                          width: 0.9.sw,
                          child: Text(
                            errorMessage ?? '',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelMedium!.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                      40.verticalSpace,
                      StyledButton(
                        onPressed: onPressedNext,
                        child: Text('NEXT'),
                      ),
                      60.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
