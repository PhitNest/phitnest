import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../view.dart';

class RequestLocationView extends ScreenView {
  final VoidCallback onPressedExit;
  final String errorMessage;

  const RequestLocationView({
    required this.onPressedExit,
    required this.errorMessage,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            200.verticalSpace,
            SizedBox(
                width: 291.w,
                child: Text(
                  'Where is your\nfitness club?',
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                )),
            42.verticalSpace,
            SizedBox(
                width: 291.w,
                child: Text(
                  'Please allow location permissions in your phone settings:',
                  style: theme.textTheme.labelLarge,
                  textAlign: TextAlign.center,
                )),
            40.verticalSpace,
            Text(
              errorMessage,
              style: theme.textTheme.labelLarge!
                  .copyWith(color: theme.colorScheme.error),
              textAlign: TextAlign.center,
            ),
            Expanded(child: Container()),
            TextButton(
              onPressed: onPressedExit,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Text(
                'EXIT',
                style: theme.textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline),
              ),
            ),
            37.verticalSpace
          ],
        ),
      );
}
