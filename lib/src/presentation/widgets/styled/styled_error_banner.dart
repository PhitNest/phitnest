import 'dart:async';

import 'package:flutter/material.dart';

import '../../../common/failure.dart';
import '../../../common/theme.dart';

class StyledErrorBanner extends MaterialBanner {
  final Failure failure;

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey();

  static void show(Failure failure) {
    scaffoldMessengerKey.currentState?.showMaterialBanner(
      StyledErrorBanner._(
        failure: failure,
      ),
    );
  }

  static void dismiss() {
    scaffoldMessengerKey.currentState?.clearMaterialBanners();
  }

  StyledErrorBanner._({
    required this.failure,
  }) : super(
          content: Text(
            failure.message,
            style: theme.textTheme.bodySmall!.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          padding: EdgeInsets.all(10),
          elevation: 8,
          onVisible: () => Future.delayed(Duration(seconds: 3)).then(
            (_) => dismiss(),
          ),
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
          ),
          actions: [
            TextButton(
              onPressed: dismiss,
              child: Text(
                'Dismiss',
                style: theme.textTheme.bodySmall,
              ),
            )
          ],
        );
}
