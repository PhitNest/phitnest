import 'dart:async';

import 'package:flutter/material.dart';

import '../theme.dart';

final class StyledBanner extends MaterialBanner {
  final String message;
  final bool error;

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void show({required String message, required bool error}) {
    scaffoldMessengerKey.currentState?.showMaterialBanner(
      StyledBanner._(
        message: message,
        error: error,
      ),
    );
  }

  static void dismiss() {
    scaffoldMessengerKey.currentState?.clearMaterialBanners();
  }

  StyledBanner._({
    required this.message,
    required this.error,
  }) : super(
          content: Text(
            message,
            style: theme.textTheme.bodySmall!.copyWith(
              color: Colors.black,
            ),
          ),
          padding: const EdgeInsets.all(10),
          elevation: 8,
          onVisible: () =>
              Future<void>.delayed(const Duration(seconds: 3)).then(
            (_) => dismiss(),
          ),
          backgroundColor: Colors.white,
          leading: error
              ? const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                )
              : const Icon(
                  Icons.info_outline,
                  color: Colors.green,
                ),
          actions: [
            const TextButton(
              onPressed: dismiss,
              child: Text(
                'Dismiss',
              ),
            )
          ],
        );
}
