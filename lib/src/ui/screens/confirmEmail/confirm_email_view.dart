import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class LoadingView extends _BaseWidget {
  LoadingView()
      : super(
          child: Column(
            children: [
              Spacer(),
              Center(
                child: CircularProgressIndicator(),
              ),
              100.verticalSpace,
            ],
          ),
          onCompletedVerification: (_) {},
        );
}

class ErrorView extends _BaseWidget {
  final String errorMessage;
  final VoidCallback onPressedResend;

  ErrorView({
    required this.errorMessage,
    required this.onPressedResend,
    required super.onCompletedVerification,
  }) : super(
          child: Column(
            children: [
              20.verticalSpace,
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.errorColor,
                ),
              ),
              Spacer(),
              TextButtonWidget(
                onPressed: onPressedResend,
                text: 'RESEND CODE',
              ),
              37.verticalSpace,
            ],
          ),
        );
}

class InitialView extends _BaseWidget {
  final VoidCallback onPressedResend;

  InitialView({
    required this.onPressedResend,
    required super.onCompletedVerification,
  }) : super(
          child: Column(
            children: [
              Spacer(),
              TextButtonWidget(
                onPressed: onPressedResend,
                text: 'RESEND CODE',
              ),
              37.verticalSpace,
            ],
          ),
        );
}

class _BaseWidget extends StatelessWidget {
  final Widget child;
  final void Function(String code) onCompletedVerification;

  const _BaseWidget({
    required this.child,
    required this.onCompletedVerification,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        useBackButton: true,
        onPressedBack: () => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => LoginProvider(),
          ),
          (_) => false,
        ),
        body: Column(
          children: [
            30.verticalSpace,
            Text(
              "Please confirm\nthat it's you.",
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineLarge,
            ),
            40.verticalSpace,
            Text(
              "Check your email for a verification\ncode from us and enter it below",
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge,
            ),
            60.verticalSpace,
            VerificationCode(
              underlineColor: Colors.black,
              onCompleted: onCompletedVerification,
              onEditing: (_) {},
              length: 6,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              itemSize: 40.w,
            ),
            Expanded(child: child),
          ],
        ),
      );
}
