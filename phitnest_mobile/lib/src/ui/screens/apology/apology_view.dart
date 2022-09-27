import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ApologyView extends ScreenView {
  Widget createTextField(BuildContext context, String hint,
          TextEditingController controller) =>
      SizedBox(
          height: 34.h,
          child: TextField(
              controller: controller,
              style: Theme.of(context).textTheme.labelMedium,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                  hintText: hint,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Color(0xFF999999)),
                  border: MaterialStateUnderlineInputBorder.resolveWith(
                      (state) => UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFDADADA)))))));

  final Function() onPressedContactUs;
  final Function() onPressedSubmit;
  final TextEditingController nameController;
  final TextEditingController emailController;

  const ApologyView(
      {required this.onPressedContactUs,
      required this.onPressedSubmit,
      required this.nameController,
      required this.emailController});

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SingleChildScrollView(
              child: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Column(children: [
          120.verticalSpace,
          SizedBox(
              width: 301.w,
              child: Text(
                "We apologize",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              )),
          40.verticalSpace,
          SizedBox(
              width: 301.w,
              child: Text(
                "PhitNest is currently available to select fitness club locations only.\n\n\nMay we contact you when this changes?",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              )),
          40.verticalSpace,
          SizedBox(
              width: 291.w,
              child: Form(
                child: Column(children: [
                  createTextField(context, 'Name', nameController),
                  16.verticalSpace,
                  createTextField(context, 'Email', emailController)
                ]),
              )),
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
              child: Text('CONTACT US',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline))),
          41.verticalSpace,
        ]),
      )));
}
