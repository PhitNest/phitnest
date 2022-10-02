import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ContactUsView extends ScreenView {
  Widget createTextField(BuildContext context, String hint,
          TextEditingController controller) =>
      SizedBox(
          height: 34.h,
          child: TextField(
              controller: controller,
              style: Theme.of(context).textTheme.labelMedium,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  hintText: hint,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Color(0xFF999999)),
                  border: MaterialStateUnderlineInputBorder.resolveWith(
                      (state) => UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFDADADA)))))));

  final Function() onPressedExit;
  final Function() onPressedSubmit;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController feedbackController;
  final int maxFeedbackLength;

  const ContactUsView(
      {required this.onPressedExit,
      required this.onPressedSubmit,
      required this.nameController,
      required this.emailController,
      required this.feedbackController,
      required this.maxFeedbackLength})
      : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(children: [
          80.verticalSpace,
          SizedBox(
              width: 301.w,
              child: Text(
                "How are we doing?",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              )),
          40.verticalSpace,
          SizedBox(
              width: 301.w,
              child: Text(
                "Your input is invaluable in building stronger and healthier\ncommunities together.",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              )),
          30.verticalSpace,
          SizedBox(
              width: 291.w,
              child: Form(
                child: Column(children: [
                  createTextField(context, 'Name', nameController),
                  16.verticalSpace,
                  createTextField(context, 'Email', emailController),
                  42.verticalSpace,
                  SizedBox(
                    height: 106.h,
                    child: TextField(
                        controller: feedbackController,
                        textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.left,
                        expands: true,
                        maxLines: null,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(16),
                            hintText: 'Your feedback',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Color(0xFF999999)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF999999)),
                                borderRadius: BorderRadius.circular(8)))),
                  )
                ]),
              )),
          39.verticalSpace,
          StyledButton(
            child: Text('SUBMIT'),
            onPressed: onPressedSubmit,
          ),
          Expanded(child: Container()),
          TextButton(
              onPressed: onPressedExit,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent)),
              child: Text('EXIT',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline))),
          37.verticalSpace,
        ]),
      );
}
