import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

bool usePreview = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  ProgressWidget.initialize(COLOR_PRIMARY);
  setupLocator();
  runApp(DevicePreview(
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
  ));
}
