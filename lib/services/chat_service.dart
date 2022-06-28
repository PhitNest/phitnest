import 'dart:async';

import '../models/models.dart';

abstract class ChatService {
  Stream<dynamic> get foregroundMessageStream;

  StreamSubscription<dynamic> openForegroundMessageStream(
          Function(dynamic message) receiveMessage) =>
      foregroundMessageStream.listen(receiveMessage);

  Stream<ChatMessage?> getMessagesToUser(String recipientId,
      {int quantity = 1});

  Stream<ChatMessage?> getMessagesFromUser(String authorId, {int quantity = 1});

  Future<bool> requestNotificationPermissions();

  Future<bool> sendMessage();

  receiveBackgroundMessageCallback(dynamic message);
}
