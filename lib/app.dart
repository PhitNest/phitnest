import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'services/authentication_service.dart';
import 'ui/screens/auth/auth_view.dart';
import 'ui/screens/onBoarding/on_boarding_view.dart';

class PhitnestApp extends StatefulWidget {
  @override
  _PhitnestAppState createState() => _PhitnestAppState();
}

class _PhitnestAppState extends State<PhitnestApp> with WidgetsBindingObserver {
  /// this key is used to navigate to the appropriate screen when the
  /// notification is clicked from the system tray
  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthenticationService(),
        child: MaterialApp(
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
              case '/auth':
                return MaterialPageRoute(builder: (_) => AuthView());
              default:
                return MaterialPageRoute(builder: (_) => OnBoardingView());
            }
          },
        ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
