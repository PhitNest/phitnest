import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/theme.dart';
import '../../../../widgets/widgets.dart';

class UploadLoading extends _UploadLoadingBase {
  const UploadLoading({
    Key? key,
  }) : super(
          key: key,
          child: const CircularProgressIndicator(),
        );
}

class UploadLoadingError extends _UploadLoadingBase {
  final String errorMessage;
  final VoidCallback onPressedRetry;

  UploadLoadingError({
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

abstract class _UploadLoadingBase extends StatelessWidget {
  final Widget child;

  const _UploadLoadingBase({
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
