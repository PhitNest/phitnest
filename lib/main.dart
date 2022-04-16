import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phitnest/firebase_options.dart';
import 'package:phitnest/helpers/helper.dart';
import 'package:phitnest/model/app_model.dart';
import 'package:phitnest/model/conversation_model.dart';
import 'package:phitnest/model/home_conversation_model.dart';
import 'package:phitnest/ui/auth/auth_screen.dart';
import 'package:phitnest/ui/chat/chat_screen.dart';
import 'package:phitnest/ui/home/home_screen.dart';
import 'package:phitnest/ui/onBoarding/on_boarding_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart' as Constants;
import 'model/user.dart';

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
  /// This is a reference to the current signed in user.
  static User? currentUser;

  /// This stream listens for refresh tokens from firebase.
  static StreamSubscription? _tokenStream;

  /// this key is used to navigate to the appropriate screen when the
  /// notification is clicked from the system tray.
  static GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');

  const PhitnestApp({Key? key}) : super(key: key);

  // Define an async function to initialize FlutterFire
  void initializeFirebase(BuildContext context) async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _handleNotification(initialMessage.data, _navigatorKey);
      }
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage? remoteMessage) {
        if (remoteMessage != null) {
          _handleNotification(remoteMessage.data, _navigatorKey);
        }
      });
      if (!Platform.isIOS) {
        FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
      }
      _tokenStream =
          FirebaseUtils.firebaseMessaging.onTokenRefresh.listen((event) {
        if (PhitnestApp.currentUser != null) {
          print('token $event');
          PhitnestApp.currentUser!.fcmToken = event;
          FirebaseUtils.updateCurrentUser(PhitnestApp.currentUser!);
        }
      });
      // Set `initialized` state to true if Firebase initialization succeeds
      Provider.of<AppModel>(context, listen: false).initialized = true;
    } catch (e) {
      // Set `error` state to true if Firebase initialization fails
      Provider.of<AppModel>(context, listen: false).error = true;
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
    if (auth.FirebaseAuth.instance.currentUser != null &&
        PhitnestApp.currentUser != null) {
      if (state == AppLifecycleState.paused) {
        //user offline
        _tokenStream?.pause();
        PhitnestApp.currentUser!.active = false;
        PhitnestApp.currentUser!.lastOnlineTimestamp = Timestamp.now();
        FirebaseUtils.updateCurrentUser(PhitnestApp.currentUser!);
      } else if (state == AppLifecycleState.resumed) {
        //user online
        _tokenStream?.resume();
        PhitnestApp.currentUser!.active = true;
        FirebaseUtils.updateCurrentUser(PhitnestApp.currentUser!);
      }
    }
  }
}

class Redirector extends StatelessWidget {
  const Redirector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    redirect(context);
    return Scaffold(
      backgroundColor: Color(Constants.COLOR_PRIMARY),
      body: Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(Color(Constants.COLOR_PRIMARY)),
          backgroundColor:
              DisplayUtils.isDarkMode(context) ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Future redirect(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool finishedOnBoarding =
        (prefs.getBool(Constants.FINISHED_ON_BOARDING) ?? false);

    if (finishedOnBoarding) {
      auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        User? user = await FirebaseUtils.getCurrentUser(firebaseUser.uid);
        if (user != null) {
          user.active = true;
          await FirebaseUtils.updateCurrentUser(user);
          PhitnestApp.currentUser = user;
          NavigationUtils.pushReplacement(context, HomeScreen(user: user));
        } else {
          NavigationUtils.pushReplacement(context, AuthScreen());
        }
      } else {
        NavigationUtils.pushReplacement(context, AuthScreen());
      }
    } else {
      NavigationUtils.pushReplacement(context, OnBoardingScreen());
    }
  }
}

void _handleNotification(
    Map<String, dynamic> message, GlobalKey<NavigatorState> navigatorKey) {
  /// right now we only handle click actions on chat messages only
  try {
    if (message.containsKey('members') &&
        message.containsKey('isGroup') &&
        message.containsKey('conversationModel')) {
      List<User> members = List<User>.from(
          (jsonDecode(message['members']) as List<dynamic>)
              .map((e) => User.fromPayload(e))).toList();
      bool isGroup = jsonDecode(message['isGroup']);
      ConversationModel conversationModel = ConversationModel.fromPayload(
          jsonDecode(message['conversationModel']));
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            homeConversationModel: HomeConversationModel(
              members: members,
              isGroupChat: isGroup,
              conversationModel: conversationModel,
            ),
          ),
        ),
      );
    }
  } catch (e, s) {
    print('MyAppState._handleNotification $e $s');
  }
}

/// this faction is called when the notification is clicked from system tray
/// when the app is in the background or completely killed

Future<dynamic> backgroundMessageHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
  Map<dynamic, dynamic> message = remoteMessage.data;
  if (message.containsKey('data')) {
    // Handle data message
    print('backgroundMessageHandler message.containsKey(data)');
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('backgroundMessageHandler message.containsKey(notification)');
  }
}
