import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ui/screens/screens.dart';
import 'ui/theme.dart';

/// Use flutter run --dart-define="USE_PREVIEW=true" or add USE_PREVIEW=true to .env
/// to use device preview.
const usePreview = bool.fromEnvironment("USE_PREVIEW", defaultValue: false);

/// This is the base Flutter [MaterialApp] instance.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DevicePreview(
        enabled: usePreview,
        builder: (context) => ScreenUtilInit(
          minTextAdapt: true,
          // Do not change this. This corresponds to the Figma resolution.
          designSize: const Size(375, 667),
          builder: (context, child) => MaterialApp(
            title: 'PhitNest',
            theme: theme,
            debugShowCheckedModeBanner: false,
            // The app always enters at the on boarding screen.
            home: OnBoardingProvider(),
          ),
        ),
      );
}
