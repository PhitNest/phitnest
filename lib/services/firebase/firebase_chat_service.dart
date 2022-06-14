import 'package:firebase_messaging/firebase_messaging.dart';

import '../services.dart';

class FirebaseChatService extends ChatService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Stream<RemoteMessage> get foregroundMessageStream =>
      FirebaseMessaging.onMessage;

  Future<bool> requestNotificationPermissions() async =>
      (await messaging.requestPermission()).authorizationStatus ==
      AuthorizationStatus.authorized;

  Future<bool> sendMessage() async {
    return false;
  }

  receiveBackgroundMessageCallback(dynamic message) {}
}
