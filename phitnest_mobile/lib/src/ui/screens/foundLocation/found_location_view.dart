import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../view.dart';

class FoundLocationView extends ScreenView {
  final Function() onPressedNo;
  final Address address;

  const FoundLocationView({required this.onPressedNo, required this.address});

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.3,
            bottom: MediaQuery.of(context).size.height * 0.061),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Is this your\nfitness club?',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Text(
            '${address.streetAddress}\n${address.city}, ${address.state} ${address.zipCode}',
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          Expanded(child: Container()),
          TextButton(
              onPressed: onPressedNo,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent)),
              child: Text('NO, IT\'S NOT',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline)))
        ]),
      ));
}
