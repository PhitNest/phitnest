import 'package:flutter/material.dart';

import '../../../common/widgets.dart';

class IntroPage extends StatelessWidget {
  EdgeInsets margin(BuildContext context) => EdgeInsets.only(
      top: MediaQuery.of(context).size.height * 0.3, bottom: 51);

  final String title;
  final String subtitle;

  const IntroPage({required this.title, required this.subtitle}) : super();

  @override
  Widget build(BuildContext context) => Container(
        margin: margin(context),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Text(
            subtitle,
            style:
                Theme.of(context).textTheme.labelLarge!.copyWith(height: 1.56),
            textAlign: TextAlign.center,
          ),
          Expanded(child: Container()),
          Arrow(width: 71, height: 10)
        ]),
      );
}
