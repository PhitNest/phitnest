import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/theme.dart';
import '../../../../widgets/widgets.dart';

class CameraLoading extends _CameraLoadingBase {
  const CameraLoading({
    Key? key,
  }) : super(
          key: key,
          child: const CircularProgressIndicator(),
        );
}

class CameraLoadingError extends _CameraLoadingBase {
  final String errorMessage;
  final VoidCallback onPressedRetry;

  CameraLoadingError({
    Key? key,
    required this.errorMessage,
    required this.onPressedRetry,
  }) : super(
          key: key,
          child: Column(
            children: [
              Text(
                errorMessage,
                style: theme.textTheme.labelLarge!
                    .copyWith(color: theme.errorColor),
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              StyledButton(
                text: 'RETRY',
                onPressed: onPressedRetry,
              ),
            ],
          ),
        );
}

abstract class _CameraLoadingBase extends StatelessWidget {
  final Widget child;

  const _CameraLoadingBase({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            40.verticalSpace,
            StyledBackButton(),
            160.verticalSpace,
            child,
          ],
        ),
      );
}
