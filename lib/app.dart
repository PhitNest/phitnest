import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'constants/constants.dart';
import 'models/models.dart';
import 'ui/screens/screens.dart';

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
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  /// Used to generate a material page route for a given view.
  generateRoute(Widget view) => MaterialPageRoute(builder: (_) => view);

  @override
  Widget build(BuildContext context) => MaterialApp(
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
        color: kColorPrimary,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              return generateRoute(HomeProvider());
            case '/resetPassword':
              return generateRoute(ForgotPasswordProvider());
            case '/mobileAuth':
              return generateRoute(MobileAuthenticationProvider());
            case '/signIn':
              return generateRoute(SignInProvider());
            case '/register':
              return generateRoute(RegisterProvider());
            case '/auth':
              return generateRoute(AuthProvider());
            case '/chat':
              return generateRoute(ChatMessagingProvider(
                  conversation: settings.arguments as Conversation));
            default:
              return generateRoute(OnBoardingProvider());
          }
        },
      );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
