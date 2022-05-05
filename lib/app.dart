import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:display/display.dart' as DisplayUtils;

import 'ui/views/views.dart';
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
        error: Theme.of(context).errorColor);

    return MaterialApp(
      navigatorKey: _navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Phitnest',
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
            return generateRoute(const ProfileView());
          case '/home':
            return generateRoute(const HomeView());
          case '/resetPassword':
          case '/mobileAuth':
          case '/login':
            return generateRoute(const LoginView());
          case '/signUp':
            return generateRoute(const SignupView());
          case '/auth':
            return generateRoute(const AuthView());
          default:
            return generateRoute(const OnBoardingView());
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
