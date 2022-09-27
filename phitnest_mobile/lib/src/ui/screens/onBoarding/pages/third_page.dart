import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets.dart';

class ThirdPage extends StatelessWidget {
  final Function() onPressedYes;
  final Function() onPressedNo;

  const ThirdPage({required this.onPressedYes, required this.onPressedNo})
      : super();

  @override
  Widget build(BuildContext context) => Column(children: [
        200.verticalSpace,
        SizedBox(
            width: 213.w,
            child: Text(
              'Let\'s get started',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            )),
        40.verticalSpace,
        SizedBox(
            width: 291.w,
            child: Text(
              'Do you belong to a fitness club?',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(height: 1.56),
              textAlign: TextAlign.center,
            )),
        40.verticalSpace,
        StyledButton(child: Text('YES'), onPressed: onPressedYes),
        Expanded(child: Container()),
        TextButton(
            onPressed: onPressedNo,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent)),
            child: Text('NO, I DON\'T',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline))),
        41.verticalSpace,
      ]);
}
