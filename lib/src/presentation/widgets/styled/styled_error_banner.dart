import 'package:flutter/material.dart';

import '../../../common/theme.dart';

class StyledErrorBanner extends MaterialBanner {
  final String err;
  final BuildContext context;

  StyledErrorBanner({
    required this.err,
    required this.context,
  }) : super(
          content: Text(
            err,
            style: theme.textTheme.bodySmall!.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          padding: EdgeInsets.all(10),
          elevation: 8,
          onVisible: () => Future.delayed(Duration(seconds: 3)).then(
            (_) => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          ),
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
          ),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: Text(
                'Dismiss',
                style: theme.textTheme.bodySmall,
              ),
            )
          ],
        );
}
