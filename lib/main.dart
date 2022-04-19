import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:phitnest/firebase_options.dart';
import 'package:phitnest/helpers/helpers.dart';
import 'package:phitnest/models/models.dart';

import 'package:phitnest/widgets/redirectorWidget/redirector_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:phitnest/constants/constants.dart' as Constants;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar'), Locale('fr')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        useFallbackTranslations: true,
        child: ChangeNotifierProvider(
            create: (context) => AppModel(),
            builder: (context, child) => const PhitnestApp())),
  );
}

class PhitnestApp extends StatelessWidget with WidgetsBindingObserver {
  /// this key is used to navigate to the appropriate screen when the
  /// notification is clicked from the system tray.
  static GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');

  const PhitnestApp({Key? key}) : super(key: key);

  // Define an async function to initialize FlutterFire
  void initializeFirebase(BuildContext context) async {
    // Update the model without listening for changes.
    AppModel model = Provider.of<AppModel>(context, listen: false);

    try {
      // Initialize notification services
      await NotificationUtils.initializeNotifications(_navigatorKey);

      // Initialize the firebase messaging token stream
      FirebaseUtils.initializeTokenStream();

      // Set initialized state to true if Firebase initialization succeeds
      model.initialized = true;
    } catch (e) {
      // Set error state to true if Firebase initialization fails
      model.error = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeFirebase(context);
    WidgetsBinding.instance?.addObserver(this);

    return Consumer<AppModel>(builder: ((context, model, child) {
      // Show error message if initialization failed
      if (model.error) {
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
      if (!model.initialized) {
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      }

      return MaterialApp(
          navigatorKey: _navigatorKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Phitnest',
          theme: ThemeData(
              bottomSheetTheme: BottomSheetThemeData(
                  backgroundColor: Colors.white.withOpacity(.9)),
              colorScheme:
                  ColorScheme.light(secondary: Color(Constants.COLOR_PRIMARY)),
              brightness: Brightness.light),
          darkTheme: ThemeData(
              bottomSheetTheme: BottomSheetThemeData(
                  backgroundColor: Colors.black12.withOpacity(.3)),
              colorScheme:
                  ColorScheme.dark(secondary: Color(Constants.COLOR_PRIMARY)),
              brightness: Brightness.dark),
          debugShowCheckedModeBanner: false,
          color: Color(Constants.COLOR_PRIMARY),
          home: const Redirector());
    }));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    FirebaseUtils.updateTokenStream(state);
  }
}
