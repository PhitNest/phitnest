import 'package:flutter/material.dart';

import '../view.dart';

class ApologyView extends ScreenView {
  final Function() onPressedContactUs;

  const ApologyView({required this.onPressedContactUs});

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.18),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            "We apologize",
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Text(
            "PhitNest is currently available to\nselect fitness club locations only.",
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(bottom: 34),
            child: TextButton(
                onPressed: onPressedContactUs,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent)),
                child: Text('CONTACT US',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        letterSpacing: 0.02,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline))),
          )
        ]),
      ));
}
