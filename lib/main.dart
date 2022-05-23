import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';

import 'app.dart';
import 'constants/constants.dart';
import 'test_app.dart';
import 'locator.dart';

bool testMode = false;
bool usePreview = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(DevicePreview(
      enabled: usePreview,
      builder: (context) {
        ProgressWidget.initialize(COLOR_PRIMARY);

        // Set up easy localization
        return EasyLocalization(
          supportedLocales: [Locale('en'), Locale('ar'), Locale('fr')],
          path: 'assets/translations',
          fallbackLocale: Locale('en'),
          useFallbackTranslations: true,
          child: testMode ? TestApp() : PhitnestApp(),
        );
      }));
}
