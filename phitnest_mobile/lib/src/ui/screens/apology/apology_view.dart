import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ApologyView extends ScreenView {
  final Function() onPressedContactUs;
  final Function() onPressedSubmit;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final AutovalidateMode autovalidateMode;
  final String? Function(String?) validateFirstName;
  final String? Function(String?) validateEmail;
  final GlobalKey<FormState> formKey;

  const ApologyView(
      {required this.onPressedContactUs,
      required this.onPressedSubmit,
      required this.nameController,
      required this.emailController,
      required this.autovalidateMode,
      required this.validateFirstName,
      required this.validateEmail,
      required this.formKey});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            120.verticalSpace,
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
                "PhitNest is currently available to select fitness club locations only.\n\n\nMay we contact you when this changes?",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
            ),
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
                        controller: nameController,
                        hint: 'Name',
                        validator: validateFirstName),
                  ),
                  16.verticalSpace,
                  SizedBox(
                    height: 34.h,
                    child: TextInputField(
                        controller: emailController,
                        hint: 'Email',
                        validator: validateEmail),
                  ),
                ]),
              ),
            ),
            42.verticalSpace,
            StyledButton(
              child: Text('SUBMIT'),
              onPressed: onPressedSubmit,
            ),
            Expanded(child: Container()),
            TextButton(
              onPressed: onPressedContactUs,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent)),
              child: Text(
                'CONTACT US',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline),
              ),
            ),
            37.verticalSpace,
          ],
        ),
      );
}
