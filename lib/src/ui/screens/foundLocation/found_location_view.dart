import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../entities/entities.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class FoundLocationView extends ScreenView {
  final Function() onPressedNo;
  final Function() onPressedYes;
  final AddressEntity address;

  const FoundLocationView({
    required this.onPressedNo,
    required this.address,
    required this.onPressedYes,
  });

  @override
  bool showAppBar(BuildContext context) => false;

  @override
  Widget buildView(BuildContext context) => Column(children: [
        200.verticalSpace,
        SizedBox(
          width: 321.w,
          child: Text(
            'Is this your\nfitness club?',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(height: 1.2),
            textAlign: TextAlign.center,
          ),
        ),
        42.verticalSpace,
        SizedBox(
          width: 291.w,
          child: Text(
            address.toString(),
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ),
        40.verticalSpace,
        StyledButton(
          onPressed: onPressedYes,
          child: Text('YES'),
        ),
        Expanded(child: Container()),
        TextButton(
          onPressed: onPressedNo,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: Text(
            'NO, IT\'S NOT',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline),
          ),
        ),
        37.verticalSpace,
      ]);
}
