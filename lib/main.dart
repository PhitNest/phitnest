import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phitnest/locator.dart';
import 'package:phitnest/model/ConversationModel.dart';
import 'package:phitnest/model/HomeConversationModel.dart';
import 'package:phitnest/services/FirebaseHelper.dart';
import 'package:phitnest/services/helper.dart';
import 'package:phitnest/ui/screens/auth/AuthScreen.dart';
import 'package:phitnest/ui/screens/chat/ChatScreen.dart';
import 'package:phitnest/ui/screens/home/HomeScreen.dart';
import 'package:phitnest/ui/screens/onBoarding/OnBoardingScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'constants/constants.dart' as Constants;
import 'model/User.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      useFallbackTranslations: true,
      child: PhitnestApp(),
    ),
  );
}
