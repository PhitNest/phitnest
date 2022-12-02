import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_mobile/src/ui/screens/message/message_provider.dart';

import 'ui/theme.dart';

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
            home: MessageProvider(),
          ),
        ),
      );
}
