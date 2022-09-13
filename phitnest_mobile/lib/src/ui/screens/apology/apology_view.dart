import 'package:flutter/material.dart';

import '../view.dart';

class ApologyView extends ScreenView {
  EdgeInsets margin(BuildContext context) => EdgeInsets.only(
      top: MediaQuery.of(context).size.height * 0.18, bottom: 41);

  final Function() onPressedContactUs;

  const ApologyView({required this.onPressedContactUs});

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
            "PhitNest is currently available to\nselect fitness club locations only.\n\nMay we contact you when this\nchanges?",
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Container(
              width: 271,
              child: Form(
                child: Column(children: [
                  TextField(
                      style: Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                          hintText: 'Name',
                          border: MaterialStateUnderlineInputBorder.resolveWith(
                              (state) => state.contains(MaterialState.focused)
                                  ? UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF999999)))
                                  : UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFDADADA)))))),
                ]),
              )),
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
