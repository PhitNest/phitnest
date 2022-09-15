import 'package:flutter/material.dart';

import '../view.dart';

class RequestLocationView extends ScreenView {
  final Function() onPressedExit;

  const RequestLocationView({required this.onPressedExit}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.3,
            bottom: MediaQuery.of(context).size.height * 0.061),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Where is your\nfitness club?',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Text(
            'Please allow location permissions\nin your phone settings:',
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          Expanded(child: Container()),
          TextButton(
              onPressed: onPressedExit,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent)),
              child: Text('EXIT',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline)))
        ]),
      ));
}
