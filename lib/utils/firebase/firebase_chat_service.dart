import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/models.dart';
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

  Stream<ChatMessage?> getMessagesFromUser(String authorId,
          {int quantity = 1}) =>
      databaseService.streamChatMessageDocuments(
          authorId, authService.userModel!.userId,
          quantity: quantity);

  receiveBackgroundMessageCallback(dynamic message) {}

  @override
  Stream<ChatMessage?> getMessagesToUser(String recipientId,
          {int quantity = 1}) =>
      databaseService.streamChatMessageDocuments(
          authService.userModel!.userId, recipientId,
          quantity: quantity);
}
