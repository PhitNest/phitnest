import 'package:flutter/material.dart';

import '../../../common/widgets.dart';

class PageThree extends StatelessWidget {
  final Function() onPressedYes;
  final Function() onPressedNo;

  const PageThree({required this.onPressedYes, required this.onPressedNo})
      : super();

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Let\'s get started',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Do you belong to a fitness club?',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              )),
          StyledButton(context, text: 'YES', onPressed: onPressedYes),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(bottom: 34),
            child: TextButton(
                onPressed: onPressedNo,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent)),
                child: Text('NO, I DON\'T',
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
