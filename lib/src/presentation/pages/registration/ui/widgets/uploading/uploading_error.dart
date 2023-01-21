import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/theme.dart';
import '../../../../../widgets/styled/styled.dart';

class UploadingErrorPage extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const UploadingErrorPage({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            200.verticalSpace,
            Text(
              errorMessage,
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.errorColor,
              ),
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            StyledButton(
              onPressed: onRetry,
              text: 'RETRY',
            ),
          ],
        ),
      );
}
