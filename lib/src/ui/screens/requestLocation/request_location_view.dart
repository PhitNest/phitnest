import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class RequestLocationView extends ScreenView {
  final String? errorMessage;
  final bool searching;
  final VoidCallback onPressRetry;

  const RequestLocationView({
    required this.errorMessage,
    required this.searching,
    required this.onPressRetry,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: 1.sh,
              child: Column(
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
                  Visibility(
                    child: CircularProgressIndicator(),
                    visible: searching,
                  ),
                  Visibility(
                    visible: errorMessage != null,
                    child: SizedBox(
                      width: 0.9.sw,
                      child: Column(
                        children: [
                          Text(
                            errorMessage ?? '',
                            style: theme.textTheme.labelLarge!
                                .copyWith(color: theme.colorScheme.error),
                            textAlign: TextAlign.center,
                          ),
                          30.verticalSpace,
                          StyledButton(
                            onPressed: onPressRetry,
                            child: Text('RETRY'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ),
      );
}
