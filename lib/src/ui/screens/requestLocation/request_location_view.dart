import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';

class _BaseWidget extends StatelessWidget {
  final List<Widget> children;
  final String headingText;

  const _BaseWidget({
    required this.children,
    required this.headingText,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            200.verticalSpace,
            SizedBox(
              child: Text(
                headingText,
                style: theme.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
            42.verticalSpace,
            ...children,
          ],
        ),
      );
}

class FetchingLocationView extends _BaseWidget {
  FetchingLocationView()
      : super(
          headingText: '',
          children: [
            Text(
              'Please allow location permissions\nin your phone settings',
              style: theme.textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            CircularProgressIndicator(),
          ],
        );
}

class FetchingGymView extends _BaseWidget {
  FetchingGymView()
      : super(
          headingText: 'Finding your\nfitness club...',
          children: [
            CircularProgressIndicator(),
          ],
        );
}

class ErrorView extends _BaseWidget {
  final String errorMessage;
  final VoidCallback onPressedRetry;

  ErrorView({
    required this.errorMessage,
    required this.onPressedRetry,
  }) : super(
          headingText: 'Could not find\nyour fitness club',
          children: [
            Text(
              errorMessage,
              style:
                  theme.textTheme.labelLarge!.copyWith(color: theme.errorColor),
              textAlign: TextAlign.center,
            ),
            30.verticalSpace,
            StyledButton(
              onPressed: onPressedRetry,
              child: Text('RETRY'),
            ),
          ],
        );
}
