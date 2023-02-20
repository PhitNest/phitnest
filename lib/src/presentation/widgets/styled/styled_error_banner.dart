import 'dart:async';

import 'package:flutter/material.dart';

import '../../../common/failure.dart';
import '../../../common/theme.dart';

class StyledErrorBanner {
  BuildContext? _owningContext;
  final Failure failure;

  StyledErrorBanner({
    required this.failure,
  });

  void show(BuildContext owningContext) {
    _owningContext = owningContext;
    ScaffoldMessenger.of(owningContext).showMaterialBanner(
      _StyledErrorBannerWidget(
        err: failure.message,
        context: owningContext,
      ),
    );
  }

  void dismiss() async {
    if (_owningContext != null) {
      try {
        ScaffoldMessenger.of(_owningContext!).hideCurrentMaterialBanner();
      } catch (_) {}
    }
  }
}

class _StyledErrorBannerWidget extends MaterialBanner {
  final String err;
  final BuildContext context;

  _StyledErrorBannerWidget({
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
            (_) {
              try {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              } catch (_) {}
            },
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
