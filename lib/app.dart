import 'package:device/device.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';

import 'ui/screens/providers.dart';
import 'constants/constants.dart';

/// Base MaterialApp widget
class PhitnestApp extends StatefulWidget {
  const PhitnestApp({Key? key}) : super(key: key);

  @override
  _PhitnestAppState createState() => _PhitnestAppState();
}

class _PhitnestAppState extends State<PhitnestApp> with WidgetsBindingObserver {
  /// This key is used to navigate to the appropriate screen when the
  /// notification is clicked from the system tray.
  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  /// Used to generate a material page route for a given view.
  generateRoute(Widget view) => MaterialPageRoute(builder: (_) => view);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      useInheritedMediaQuery: true,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: DevicePreview.locale(context),
      title: 'Phitnest',
      builder: (context, child) {
        ProgressWidget.initialize(COLOR_PRIMARY);
        initializeDeviceUtils(context);
        return DevicePreview.appBuilder(context, child);
      },
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(COLOR_PRIMARY),
          secondary: Color(COLOR_ACCENT),
        ),
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.white.withOpacity(.9)),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Color(COLOR_PRIMARY_DARK),
          secondary: Color(COLOR_ACCENT),
        ),
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black12.withOpacity(.3)),
      ),
      debugShowCheckedModeBanner: false,
      color: Color(COLOR_PRIMARY),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/profile':
            return generateRoute(ProfileProvider());
          case '/home':
            return generateRoute(HomeProvider());
          case '/resetPassword':
          case '/mobileAuth':
          case '/login':
            return generateRoute(LoginProvider());
          case '/signup':
            return generateRoute(SignupProvider());
          case '/auth':
            return generateRoute(AuthProvider());
          default:
            return generateRoute(OnBoardingProvider());
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
