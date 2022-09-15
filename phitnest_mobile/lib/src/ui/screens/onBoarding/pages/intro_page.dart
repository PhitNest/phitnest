import 'package:flutter/material.dart';

import '../../../common/widgets.dart';

class IntroPage extends StatelessWidget {
  final String title;
  final String subtitle;

  const IntroPage({required this.title, required this.subtitle}) : super();

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.3,
            bottom: MediaQuery.of(context).size.height * 0.076),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Text(
            subtitle,
            style:
                Theme.of(context).textTheme.labelLarge!.copyWith(height: 1.56),
            textAlign: TextAlign.center,
          ),
          Expanded(child: Container()),
          Arrow(
              width: MediaQuery.of(context).size.width * 0.19,
              height: MediaQuery.of(context).size.height * 0.015)
        ]),
      );
}
