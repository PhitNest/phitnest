import 'package:flutter/material.dart';

import '../view.dart';

class RequestLocationView extends ScreenView {
  final Function() onPressedExit;

  const RequestLocationView({required this.onPressedExit}) : super();

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Where is your fitness club?',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Please allow location permissions in your phone settings:',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              )),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(bottom: 34),
            child: TextButton(
                onPressed: onPressedExit,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent)),
                child: Text('EXIT',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Metropolis',
                        letterSpacing: 0.02,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline))),
          )
        ]),
      );
}
