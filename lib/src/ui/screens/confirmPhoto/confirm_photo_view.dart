import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';

class ErrorView extends _BaseWidget {
  final String errorMessage;
  final VoidCallback onPressedRetry;
  final VoidCallback onPressedRetake;

  ErrorView({
    required this.errorMessage,
    required this.onPressedRetry,
    required this.onPressedRetake,
  }) : super(
          child: Column(
            children: [
              Text(
                errorMessage,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.errorColor,
                ),
              ),
              20.verticalSpace,
              StyledButton(
                onPressed: onPressedRetry,
                child: Text('RETRY'),
              ),
              Spacer(),
              TextButtonWidget(
                onPressed: onPressedRetake,
                text: 'RETAKE',
              ),
              37.verticalSpace,
            ],
          ),
        );
}

class LoadingView extends _BaseWidget {
  LoadingView()
      : super(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
}

class InitialView extends _BaseWidget {
  final VoidCallback onPressedConfirm;
  final VoidCallback onPressedRetake;

  InitialView({
    required this.onPressedConfirm,
    required this.onPressedRetake,
  }) : super(
          child: Column(
            children: [
              StyledButton(
                onPressed: onPressedConfirm,
                child: Text('CONFIRM'),
              ),
              Spacer(),
              TextButtonWidget(
                onPressed: onPressedRetake,
                text: 'RETAKE',
              ),
              37.verticalSpace,
            ],
          ),
        );
}

class _BaseWidget extends StatelessWidget {
  final Widget child;

  const _BaseWidget({required this.child}) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
          children: [
            40.verticalSpace,
            Stack(
              children: [
                BackArrowButton(),
                Container(
                  padding: EdgeInsets.only(top: 10.h),
                  alignment: Alignment.center,
                  child: Text(
                    "Confirm Photo",
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
              ],
            ),
            40.verticalSpace,
            SizedBox(
              width: 262.w,
              height: 346.h,
              child: Image.asset('assets/images/phitnestSelfie.png'),
            ),
            20.verticalSpace,
            Expanded(child: child),
          ],
        ),
      );
}
