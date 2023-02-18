import 'dart:async';

import 'package:flutter/material.dart';

import '../../../common/failure.dart';
import '../../../common/theme.dart';

class StyledErrorBanner extends MaterialBanner {
  final String err;
  final BuildContext context;

  void dismiss() => ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

  static void show(BuildContext context, Failure failure, Completer dismiss) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    final banner = StyledErrorBanner._(
      err: failure.message,
      context: context,
    );
    ScaffoldMessenger.of(context).showMaterialBanner(banner);
    dismiss.future.then((_) => banner.dismiss());
  }

  StyledErrorBanner._({
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
