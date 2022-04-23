import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phitnest/helpers/helpers.dart';

import 'package:phitnest/widgets/redirectorWidget/redirector_widget.dart';
import 'package:phitnest/constants/constants.dart';

class PhitnestApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhitnestAppState();
}

class _PhitnestAppState extends State<PhitnestApp> with WidgetsBindingObserver {
  /// this key is used to navigate to the appropriate screen when the
  /// notification is clicked from the system tray.
  static GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');

  bool _error = false;
  bool _initialized = false;

  // Async function to initialize firebase
  void initializeFirebase() async {
    try {
      // Initialize notification services
      await NotificationUtils.initializeNotifications(_navigatorKey);

      // Initialize the firebase messaging token stream
      FirebaseUtils.initializeTokenStream();

      // Set initialized state to true if Firebase initialization succeeds
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set error state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 25,
            ),
            SizedBox(height: 16),
            Text(
              'Failed to initialize firebase!'.tr(),
              style: TextStyle(color: Colors.red, fontSize: 25),
            ),
          ],
        )),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    // Store theme setting for frequent use.
    DisplayUtils.isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return MaterialApp(
        navigatorKey: _navigatorKey,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Phitnest',
        theme: ThemeData(
            bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.white.withOpacity(.9)),
            colorScheme: ColorScheme.light(secondary: Color(COLOR_PRIMARY)),
            brightness: Brightness.light),
        darkTheme: ThemeData(
            bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.black12.withOpacity(.3)),
            colorScheme: ColorScheme.dark(secondary: Color(COLOR_PRIMARY)),
            brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        color: Color(COLOR_PRIMARY),
        // The redirector will route the user to the proper page
        home: const Redirector());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    FirebaseUtils.updateTokenStream(state);
  }
}