import 'package:flutter/material.dart';

import '../../common/widgets.dart';
import '../view.dart';

class ThankYouView extends ScreenView {
  final Function() onPressedBye;
  final String name;

  const ThankYouView({required this.onPressedBye, required this.name})
      : super();

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.3, bottom: 0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Thank you,\n${this.name}.',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Text(
            'We\'ll be in touch, my friend.',
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          StyledButton(
            context,
            child: Text('BYE FOR NOW!'),
            onPressed: onPressedBye,
          ),
        ]),
      ));
}
