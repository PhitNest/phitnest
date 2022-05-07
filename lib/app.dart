import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:display/display.dart' as DisplayUtils;

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
    // Initialize dark mode settings
    DisplayUtils.initialize(
        darkMode: Theme.of(context).brightness == Brightness.dark,
        primary: Color(COLOR_PRIMARY),
        accent: Color(COLOR_ACCENT),
        error: Theme.of(context).errorColor);

    return MaterialApp(
      navigatorKey: _navigatorKey,
      useInheritedMediaQuery: true,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: DevicePreview.locale(context),
      title: 'Phitnest',
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white.withOpacity(.9)),
          brightness: Brightness.light),
      darkTheme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black12.withOpacity(.3)),
          brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      color: Color(COLOR_PRIMARY),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/profile':
            return generateRoute(const ProfileProvider());
          case '/home':
            return generateRoute(const HomeProvider());
          case '/resetPassword':
          case '/mobileAuth':
          case '/login':
            return generateRoute(const LoginProvider());
          case '/signup':
            return generateRoute(const SignupProvider());
          case '/auth':
            return generateRoute(const AuthProvider());
          default:
            return generateRoute(const OnBoardingProvider());
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
