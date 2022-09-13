import 'package:flutter/material.dart';

import '../view.dart';

class ApologyView extends ScreenView {
  EdgeInsets margin(BuildContext context) => EdgeInsets.only(
      top: MediaQuery.of(context).size.height * 0.18, bottom: 41);

  final Function() onPressedContactUs;

  const ApologyView({required this.onPressedContactUs});

  @override
  Widget build(BuildContext context) => Scaffold(
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
        ]),
      ));
}
