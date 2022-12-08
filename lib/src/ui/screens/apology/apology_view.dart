import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class ApologyView extends ScreenView {
  final VoidCallback onPressedSubmit;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final AutovalidateMode autovalidateMode;
  final FormFieldValidator validateFirstName;
  final FormFieldValidator validateEmail;
  final GlobalKey<FormState> formKey;
  final ScrollController scrollController;
  final FocusNode nameFocusNode;
  final FocusNode emailFocusNode;
  final VoidCallback onTapName;
  final VoidCallback onTapEmail;

  const ApologyView({
    required this.onPressedSubmit,
    required this.scrollController,
    required this.nameController,
    required this.emailController,
    required this.autovalidateMode,
    required this.validateFirstName,
    required this.validateEmail,
    required this.formKey,
    required this.nameFocusNode,
    required this.emailFocusNode,
    required this.onTapName,
    required this.onTapEmail,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SingleChildScrollView(
            controller: scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: SizedBox(
              width: double.infinity,
              height: 1.sh,
              child: Column(
                children: [
                  110.verticalSpace,
                  SizedBox(
                    child: Text(
                      "We apologize",
                      style: theme.textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  40.verticalSpace,
                  SizedBox(
                      child: Text(
                    "PhitNest is currently available to\nselect fitness club locations only.\n\n\nMay we contact you when this\nchanges?",
                    style: theme.textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  )),
                  40.verticalSpace,
                  SizedBox(
                    width: 291.w,
                    child: Form(
                      key: formKey,
                      autovalidateMode: autovalidateMode,
                      child: Column(children: [
                        SizedBox(
                          height: 34.h,
                          child: TextInputField(
                            inputAction: TextInputAction.next,
                            controller: nameController,
                            focusNode: nameFocusNode,
                            onTap: onTapName,
                            hint: 'Name',
                            validator: validateFirstName,
                          ),
                        ),
                        16.verticalSpace,
                        SizedBox(
                          height: 34.h,
                          child: TextInputField(
                            inputAction: TextInputAction.done,
                            controller: emailController,
                            focusNode: emailFocusNode,
                            onTap: onTapEmail,
                            hint: 'Email',
                            validator: validateEmail,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  40.verticalSpace,
                  StyledButton(
                    child: Text('SUBMIT'),
                    onPressed: onPressedSubmit,
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ),
      );
}
