import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'services/services.dart';
import 'screens/screens.dart';

class App extends StatelessWidget with WidgetsBindingObserver {
  /// Holds all back end functionality and reference to current user
  final BackEndModel backendModel = FirebaseModel();

  /// this key is used to navigate to the appropriate screen when the
  /// notification is clicked from the system tray
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');

  @override
  Widget build(BuildContext context) {
    // Store theme setting for frequent use
    DisplayUtils.initialize(context);
    WidgetsBinding.instance?.addObserver(this);

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    backendModel.updateLifeCycleState(state);
  }
}
