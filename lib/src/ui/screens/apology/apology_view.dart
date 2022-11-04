import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ApologyView extends ScreenView {
  final Function() onPressedSubmit;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final AutovalidateMode autovalidateMode;
  final String? Function(String?) validateFirstName;
  final String? Function(String?) validateEmail;
  final GlobalKey<FormState> formKey;

  @override
  bool get scrollEnabled => true;

  const ApologyView(
      {required this.onPressedSubmit,
      required this.nameController,
      required this.emailController,
      required this.autovalidateMode,
      required this.validateFirstName,
      required this.validateEmail,
      required this.formKey});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          110.verticalSpace,
          SizedBox(
            width: 301.w,
            child: Text(
              "We apologize",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          40.verticalSpace,
          SizedBox(
              width: 301.w,
              child: Text(
                "PhitNest is currently available to\nselect fitness club locations only.\n\n\nMay we contact you when this\nchanges?",
                style: Theme.of(context).textTheme.labelLarge,
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
                      hint: 'Name',
                      validator: validateFirstName),
                ),
                16.verticalSpace,
                SizedBox(
                  height: 34.h,
                  child: TextInputField(
                      inputAction: TextInputAction.done,
                      controller: emailController,
                      hint: 'Email',
                      validator: validateEmail),
                ),
              ]),
            ),
          ),
          40.verticalSpace,
          StyledButton(
            child: Text('SUBMIT'),
            onPressed: onPressedSubmit,
          ),
        ],
      );
}
