import 'package:flutter/material.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ApologyView extends ScreenView {
  EdgeInsets margin(BuildContext context) => EdgeInsets.only(
      top: MediaQuery.of(context).size.height * 0.18, bottom: 41);

  Widget createTextField(BuildContext context, String hint) => Container(
      height: 40,
      child: TextField(
          style: Theme.of(context).textTheme.labelMedium,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 6),
              hintText: hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Color(0xFF999999)),
              border: MaterialStateUnderlineInputBorder.resolveWith((state) =>
                  UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDADADA)))))));

  final Function() onPressedContactUs;
  final Function() onPressedSubmit;

  const ApologyView(
      {required this.onPressedContactUs, required this.onPressedSubmit});

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: margin(context),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            "We apologize",
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Text(
            "PhitNest is currently available to\nselect fitness club locations only.\n\n\nMay we contact you when this\nchanges?",
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Container(
              width: 291,
              child: Form(
                child: Column(children: [
                  createTextField(context, 'Name'),
                  SizedBox(height: 10),
                  createTextField(context, 'Email')
                ]),
              )),
          SizedBox(height: 42),
          StyledButton(
            context,
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
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline))),
        ]),
      ));
}
