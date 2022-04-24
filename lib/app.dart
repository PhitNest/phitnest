import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'helpers/helpers.dart';
import 'models/models.dart';
import 'screens/screens.dart';

export 'constants/constants.dart';
export 'helpers/helpers.dart';
export 'models/models.dart';
export 'screens/screens.dart';
export 'widgets/widgets.dart';

class AppModel {
  /// this key is used to navigate to the appropriate screen when the
  /// notification is clicked from the system tray.
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');

  /// This is a token stream for firebase messaging. It is updated with calls to
  /// [updateLifeCycleState]
  late final StreamSubscription<String> _tokenStream;

  /// This is the current signed in user.
  UserModel? currentUser;

  AppModel() : super() {
    // When the token stream receives an event, update the users firebase
    // messaging token stored in firestore.
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      if (currentUser != null) {
        currentUser!.fcmToken = token;
        FirebaseUtils.updateCurrentUser(currentUser!);
      }
    });
  }

  /// When the app's life cycle updates, pause/resume the token stream and set
  /// the activity boolean for the user.
  void updateLifeCycleState(AppLifecycleState state) {
    UserModel? user = currentUser;
    if (FirebaseAuth.instance.currentUser != null && user != null) {
      if (state == AppLifecycleState.paused) {
        //user offline
        _tokenStream.pause();
        user.active = false;
        user.lastOnlineTimestamp = Timestamp.now();
        FirebaseUtils.updateCurrentUser(user);
      } else if (state == AppLifecycleState.resumed) {
        //user online
        _tokenStream.resume();
        user.active = true;
        FirebaseUtils.updateCurrentUser(user);
      }
    }
  }
}

class App extends StatelessWidget with WidgetsBindingObserver {
  /// This model holds the current user, token stream, and navigation key.
  final AppModel model = AppModel();

  @override
  Widget build(BuildContext context) {
    // Store theme setting for frequent use.
    DisplayUtils.isDarkMode = Theme.of(context).brightness == Brightness.dark;
    WidgetsBinding.instance?.addObserver(this);

    // Pass the model down to children so they can access the current user.
    return Provider.value(
        value: model,
        child: MaterialApp(
            navigatorKey: model.navigatorKey,
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
    model.updateLifeCycleState(state);
  }
}
