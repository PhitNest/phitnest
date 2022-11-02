import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ContactUsView extends ScreenView {
  final Function() onPressedExit;
  final Function() onPressedSubmit;
  final Function() onPressedDoneEditing;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController feedbackController;
  final int maxFeedbackLength;
  final FocusNode feedbackFocus;

  const ContactUsView(
      {required this.onPressedExit,
      required this.onPressedSubmit,
      required this.nameController,
      required this.emailController,
      required this.onPressedDoneEditing,
      required this.feedbackController,
      required this.feedbackFocus,
      required this.maxFeedbackLength})
      : super();

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        80.verticalSpace,
        SizedBox(
            width: 301.w,
            child: Text(
              "How are we doing?",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            )),
        40.verticalSpace,
        AnimatedCrossFade(
          firstChild: Container(
            width: 301.w,
            child: Text(
              "Your input is invaluable in building\nstronger and healthier\ncommunities together.",
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
          ),
          secondChild: Container(),
          duration: Duration(milliseconds: 500),
          crossFadeState: feedbackFocus.hasFocus
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        30.verticalSpace,
        SizedBox(
          width: 291.w,
          child: Form(
            child: Column(children: [
              AnimatedCrossFade(
                  firstChild: Column(children: [
                    SizedBox(
                      height: 34.h,
                      child: TextInputField(
                        hint: 'Name',
                        controller: nameController,
                        inputAction: TextInputAction.next,
                      ),
                    ),
                    16.verticalSpace,
                    SizedBox(
                      height: 34.h,
                      child: TextInputField(
                          hint: 'Email',
                          controller: emailController,
                          inputAction: TextInputAction.next),
                    ),
                    42.verticalSpace,
                  ]),
                  secondChild: Container(),
                  duration: Duration(milliseconds: 500),
                  crossFadeState: feedbackFocus.hasPrimaryFocus
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst),
              SizedBox(
                height: 106.h,
                child: TextField(
                    controller: feedbackController,
                    focusNode: feedbackFocus,
                    textAlignVertical: TextAlignVertical.top,
                    textAlign: TextAlign.left,
                    expands: true,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Your feedback',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Color(0xFF999999)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF999999)),
                            borderRadius: BorderRadius.circular(8)))),
              )
            ]),
          ),
        ),
        feedbackFocus.hasFocus ? 30.verticalSpace : 39.verticalSpace,
        StyledButton(
          child: Text(feedbackFocus.hasFocus ? 'DONE' : 'SUBMIT'),
          onPressed:
              feedbackFocus.hasFocus ? onPressedDoneEditing : onPressedSubmit,
        ),
        feedbackFocus.hasFocus
            ? 10.verticalSpace
            : Expanded(child: Container()),
        TextButton(
          onPressed:
              feedbackFocus.hasFocus ? onPressedDoneEditing : onPressedExit,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent)),
          child: Text(
            'EXIT',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline),
          ),
        ),
        37.verticalSpace,
      ]);
}
