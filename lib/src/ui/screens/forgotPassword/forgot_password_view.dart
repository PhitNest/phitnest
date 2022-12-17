import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class ForgotPasswordView extends ScreenView {
  final TextEditingController emailAddressController;
  final TextEditingController newPassController;
  final TextEditingController rewriteNewPassController;
  final VoidCallback onPressedSubmit;
  final ScrollController scrollController;
  final FocusNode emailFocus;
  final VoidCallback onTapEmail;
  final AutovalidateMode autoValidateMode;
  final GlobalKey<FormState> formKey;
  final FormFieldValidator validateEmail;
  final bool loading;
  final String? errorMessage;

  const ForgotPasswordView({
    required this.emailAddressController,
    required this.newPassController,
    required this.rewriteNewPassController,
    required this.onPressedSubmit,
    required this.scrollController,
    required this.emailFocus,
    required this.onTapEmail,
    required this.formKey,
    required this.validateEmail,
    required this.autoValidateMode,
    required this.loading,
    required this.errorMessage,
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
                    30.verticalSpace,
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
                      width: 291.w,
                      child: Form(
                        key: formKey,
                        autovalidateMode: autoValidateMode,
                        child: SizedBox(
                          child: Column(
                            children: [
                              TextInputField(
                                focusNode: emailFocus,
                                controller: emailAddressController,
                                keyboardType: TextInputType.emailAddress,
                                validator: validateEmail,
                                onTap: onTapEmail,
                                hint: 'Email',
                              ),
                              TextInputField(
                                focusNode: emailFocus,
                                controller: newPassController,
                                keyboardType: TextInputType.emailAddress,
                                validator: validateEmail,
                                onTap: onTapEmail,
                                hint: 'New Password',
                              ),
                              TextInputField(
                                focusNode: emailFocus,
                                controller: rewriteNewPassController,
                                keyboardType: TextInputType.emailAddress,
                                validator: validateEmail,
                                onTap: onTapEmail,
                                hint: 'Re-write New Password',
                              ),
                              30.verticalSpace,
                              Visibility(
                                visible: errorMessage != null,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  child: Text(
                                    errorMessage ?? "",
                                    style:
                                        theme.textTheme.labelMedium!.copyWith(
                                      color: theme.errorColor,
                                    ),
                                  ),
                                ),
                              ),
                              loading
                                  ? StyledButton(
                                      onPressed: onPressedSubmit,
                                      child: Text(
                                        errorMessage != null
                                            ? 'RETRY'
                                            : 'SUBMIT',
                                      ),
                                    )
                                  : CircularProgressIndicator(),
                            ],
                          ),
                        ),
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
