import 'package:flutter/material.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ContactUsView extends ScreenView {
  Widget createTextField(BuildContext context, String hint,
          TextEditingController controller) =>
      Container(
          height: MediaQuery.of(context).size.height * 0.06,
          child: TextField(
              controller: controller,
              style: Theme.of(context).textTheme.labelMedium,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 6),
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

  const ContactUsView(
      {required this.onPressedExit,
      required this.onPressedSubmit,
      required this.nameController,
      required this.emailController,
      required this.feedbackController});

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.12,
                bottom: MediaQuery.of(context).size.height * 0.061),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                "How are we doing?",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              Text(
                "Your input is invaluable in building\nstronger and healthier\ncommunities together.",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              Container(
                  width: MediaQuery.of(context).size.width * 0.776,
                  child: Form(
                    child: Column(children: [
                      createTextField(context, 'Name', nameController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      createTextField(context, 'Email', emailController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.063),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.159,
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.063),
              StyledButton(
                context,
                child: Text('SUBMIT'),
                onPressed: onPressedSubmit,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.0656),
              TextButton(
                  onPressed: onPressedExit,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  child: Text('EXIT',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline))),
            ]),
          ))));
}
