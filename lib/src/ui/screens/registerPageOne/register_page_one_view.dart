import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class RegisterPageOneView extends ScreenView {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final Function() onPressedNext;

  RegisterPageOneView(
      {required this.firstNameController,
      required this.lastNameController,
      required this.onPressedNext})
      : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              53.verticalSpace,
              BackArrowButton(),
              25.verticalSpace,
              Text(
                'Register',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              25.verticalSpace,
              SizedBox(
                width: 291.w,
                child: Form(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 34.h,
                        child: TextInputField(
                          hint: 'First Name',
                          controller: firstNameController,
                        ),
                      ),
                      16.verticalSpace,
                      SizedBox(
                        height: 34.h,
                        child: TextInputField(
                          hint: 'Last Name',
                          controller: lastNameController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              225.verticalSpace,
              StyledButton(
                onPressed: onPressedNext,
                child: Text('NEXT'),
              ),
              40.verticalSpace,
            ],
          ),
        ),
      );
}
