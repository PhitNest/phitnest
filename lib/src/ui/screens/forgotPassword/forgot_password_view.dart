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
  final AutovalidateMode autovalidateMode;
  final GlobalKey<FormState> formKey;
  final FormFieldValidator validateEmail;
  final bool loading;
  final String? errorMessage;

  const ForgotPasswordView({
    required this.emailAddressController,
    required this.onPressedsubmit,
    required this.scrollController,
    required this.emailFocus,
    required this.onTapEmail,
    required this.formKey,
    required this.validateEmail,
    required this.autovalidateMode,
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
                    Form(
                      key: formKey,
                      autovalidateMode: autovalidateMode,
                      child: SizedBox(
                        height: 34.h,
                        width: 291.w,
                        child: TextInputField(
                          focusNode: emailFocus,
                          controller: emailAddressController,
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                          onTap: onTapEmail,
                          hint: 'Email',
                        ),
                      ),
                    ),
                    30.verticalSpace,
                    Visibility(
                      visible: errorMessage != null,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Text(
                          errorMessage ?? "",
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: theme.errorColor,
                          ),
                        ),
                      ),
                    ),
                    loading
                        ? StyledButton(
                            onPressed: onPressedsubmit,
                            child: Text(
                              errorMessage != null ? 'RETRY' : 'SUBMIT',
                            ),
                          )
                        : CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
