import 'package:flutter/material.dart';

import '../../../common/widgets.dart';

class FinalPage extends StatelessWidget {
  EdgeInsets margin(BuildContext context) => EdgeInsets.only(
      top: MediaQuery.of(context).size.height * 0.3, bottom: 41);

  final Function() onPressedYes;
  final Function() onPressedNo;

  const FinalPage({required this.onPressedYes, required this.onPressedNo})
      : super();

  @override
  Widget build(BuildContext context) => Container(
        margin: margin(context),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Let\'s get started',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Text(
            'Do you belong to a fitness club?',
            style:
                Theme.of(context).textTheme.labelLarge!.copyWith(height: 1.56),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          StyledButton(context, child: Text('YES'), onPressed: onPressedYes),
          Expanded(child: Container()),
          TextButton(
              onPressed: onPressedNo,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent)),
              child: Text('NO, I DON\'T',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline)))
        ]),
      );
}
