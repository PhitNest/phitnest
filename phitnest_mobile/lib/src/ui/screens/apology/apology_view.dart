import 'package:flutter/material.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ApologyView extends ScreenView {
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
      body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.18,
                        bottom: MediaQuery.of(context).size.height * 0.061),
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                      Text(
                        "We apologize",
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06),
                      Text(
                        "PhitNest is currently available to\nselect fitness club locations only.\n\n\nMay we contact you when this\nchanges?",
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.776,
                          child: Form(
                            child: Column(children: [
                              createTextField(context, 'Name', nameController),
                              SizedBox(height: 10),
                              createTextField(context, 'Email', emailController)
                            ]),
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.063),
                      StyledButton(
                        context,
                        child: Text('SUBMIT'),
                        onPressed: onPressedSubmit,
                      ),
                      Expanded(child: Container()),
                      TextButton(
                          onPressed: onPressedContactUs,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent)),
                          child: Text('CONTACT US',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline))),
                    ]),
                  )))));
}
