import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'constants/constants.dart';

bool usePreview = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  ProgressWidget.initialize(kColorPrimary);
  _startApp();
}

/// Only call this from integration tests
restartTestApp() => _startApp();

_startApp() => runApp(
      DevicePreview(
        key: UniqueKey(),
        enabled: usePreview,
        builder: (context) =>
            // Set up easy localization
            EasyLocalization(
          supportedLocales: [Locale('en'), Locale('ar'), Locale('fr')],
          path: 'assets/translations',
          fallbackLocale: Locale('en'),
          useFallbackTranslations: true,
          child: PhitnestApp(),
        ),
      ),
    );