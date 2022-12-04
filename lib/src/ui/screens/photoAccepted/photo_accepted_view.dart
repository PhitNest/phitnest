import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../view.dart';
import '../../widgets/widgets.dart';

class PhotoAcceptedView extends ScreenView {
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        child: Column(
          children: [
            200.verticalSpace,
            Text(
              'Congratulations!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            40.verticalSpace,
            Text(
              'Your profile photo was approved.\nYou’re ready to meet new\nfriends.',
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.labelLarge!.copyWith(height: 1.7),
            ),
            40.verticalSpace,
            StyledButton(
                onPressed: () {},
                child: Text(
                  'START',
                ))
          ],
        ),
      );
}
