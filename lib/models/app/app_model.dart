import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:phitnest/helpers/helpers.dart';
import 'package:phitnest/models/models.dart';

class AppModel extends ChangeNotifier {
  /// This is a token stream for firebase messaging. This is initialized in
  /// [initializeTokenStream] and it is updated with calls to
  /// [updateTokenStream]
  StreamSubscription<String>? _tokenStream;

  UserModel? currentUser;

  bool _error = false;

  bool _initialized = false;

  bool get error => _error;

  bool get initialized => _initialized;

  set error(bool error) {
    _error = error;
    notifyListeners();
  }

  set initialized(bool initialized) {
    _initialized = initialized;
    notifyListeners();
  }

  /// Initializes the token stream
  void initializeTokenStream() {
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      if (currentUser != null) {
        currentUser!.fcmToken = token;
        FirebaseUtils.updateCurrentUser(currentUser!);
      }
    });
  }

  /// This will pause the token stream and set the user's status to inactive
  /// when the app life cycle transitions to [AppLifecycleState.paused].
  /// This will resume the token stream and set the user's status to active
  /// when the app life cycle transitions to [AppLifecycleState.resumed].
  void updateTokenStream(AppLifecycleState state) {
    UserModel? user = currentUser;
    if (FirebaseAuth.instance.currentUser != null && user != null) {
      if (state == AppLifecycleState.paused) {
        //user offline
        _tokenStream?.pause();
        user.active = false;
        user.lastOnlineTimestamp = Timestamp.now();
        FirebaseUtils.updateCurrentUser(user);
      } else if (state == AppLifecycleState.resumed) {
        //user online
        _tokenStream?.resume();
        user.active = true;
        FirebaseUtils.updateCurrentUser(user);
      }
    }
  }
}
