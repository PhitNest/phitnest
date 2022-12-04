import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/widgets.dart';
import '../view.dart';

class ThankYouView extends ScreenView {
  final Function() onPressedBye;
  final String name;

  const ThankYouView({required this.onPressedBye, required this.name})
      : super();

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        double.infinity.horizontalSpace,
        200.verticalSpace,
        SizedBox(
            width: 301.w,
            child: Text(
              'Thank you,\n${this.name}.',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            )),
        42.verticalSpace,
        Text(
          'We\'ll be in touch, my friend.',
          style: Theme.of(context).textTheme.labelLarge,
          textAlign: TextAlign.center,
        ),
        40.verticalSpace,
        StyledButton(
          child: Text('BYE FOR NOW'),
          onPressed: onPressedBye,
        ),
      ]);
}
