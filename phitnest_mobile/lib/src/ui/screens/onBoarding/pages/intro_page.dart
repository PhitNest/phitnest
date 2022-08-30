import 'package:flutter/material.dart';

import '../../../common/widgets.dart';

class IntroPage extends StatelessWidget {
  final String title;
  final String subtitle;

  const IntroPage({required this.title, required this.subtitle}) : super();

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          Expanded(child: Container()),
          Padding(
              padding: EdgeInsets.only(bottom: 51),
              child: Arrow(width: 71, height: 10))
        ]),
      );
}
