import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/models.dart';
import '../services.dart';

class FirebaseChatService extends ChatService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<bool> requestNotificationPermissions() async =>
      (await messaging.requestPermission()).authorizationStatus ==
      AuthorizationStatus.authorized;

  Future<bool> refreshConnection() async {
    return false;
  }

  Future<bool> sendMessage(UserModel from, UserModel to) async {
    return false;
  }

  receiveMessageCallback(UserModel from, UserModel to) {}
}
