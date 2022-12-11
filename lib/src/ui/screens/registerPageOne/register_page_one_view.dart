import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class RegisterPageOneView extends ScreenView {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final FormFieldValidator validateFirstName;
  final FormFieldValidator validateLastName;
  final AutovalidateMode autovalidateMode;
  final GlobalKey<FormState> formKey;
  final VoidCallback onPressedNext;

  RegisterPageOneView({
    required this.firstNameController,
    required this.lastNameController,
    required this.onPressedNext,
    required this.autovalidateMode,
    required this.formKey,
    required this.validateFirstName,
    required this.validateLastName,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Column(
            children: [
              40.verticalSpace,
              BackArrowButton(),
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
                          hint: 'First Name',
                          validator: validateFirstName,
                          controller: firstNameController,
                          inputAction: TextInputAction.next,
                        ),
                      ),
                      16.verticalSpace,
                      SizedBox(
                        height: 34.h,
                        child: TextInputField(
                          hint: 'Last Name',
                          validator: validateLastName,
                          controller: lastNameController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              StyledButton(
                onPressed: onPressedNext,
                child: Text('NEXT'),
              ),
              60.verticalSpace,
            ],
          ),
        ),
      );
}
