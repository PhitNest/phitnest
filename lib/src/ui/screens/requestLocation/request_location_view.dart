import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class RequestLocationView extends ScreenView {
  final VoidCallback onPressedExit;
  final String errorMessage;

  const RequestLocationView({
    required this.onPressedExit,
    required this.errorMessage,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              200.verticalSpace,
              SizedBox(
                child: Text(
                  'Where is your\nfitness club?',
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              42.verticalSpace,
              SizedBox(
                child: Text(
                  'Please allow location permissions\nin your phone settings',
                  style: theme.textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              40.verticalSpace,
              Text(
                errorMessage,
                style: theme.textTheme.labelLarge!
                    .copyWith(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
              Expanded(child: Container()),
              TextButtonWidget(
                onPressed: onPressedExit,
                text: 'EXIT',
              ),
              37.verticalSpace
            ],
          ),
        ),
      );
}
