import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'utils/utils.dart';

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
    DisplayUtils.isDarkMode = Theme.of(context).brightness == Brightness.dark;
    WidgetsBinding.instance?.addObserver(this);

    // Pass the back end down to children
    return ChangeNotifierProvider.value(
        value: backendModel,
        child: MaterialApp(
            navigatorKey: navigatorKey,
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
            home: const RedirectorScreen()));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    backendModel.updateLifeCycleState(state);
  }
}
