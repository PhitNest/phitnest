import 'dart:async';

import '../models/models.dart';
import 'services.dart';

abstract class ChatService {
  String get currentUserId => authService.userModel!.userId;

  Stream<ChatMessage?> getIncomingMessages(String authorId) =>
      databaseService.getChatMessageUpdates(authorId, currentUserId);

  Stream<ChatMessage?> getRecentChatMessagesFrom(String authorId,
          {int quantity = 1}) =>
      databaseService.getRecentChatMessages(authorId, currentUserId,
          quantity: quantity);

  Stream<ChatMessage?> getRecentChatMessagesTo(String recipientId,
          {int quantity = 1}) =>
      databaseService.getRecentChatMessages(currentUserId, recipientId,
          quantity: quantity);

  Stream<ChatMessage?> getRecentChatMessagesToAndFrom(String otherUserId,
          {int quantity = 1}) =>
      databaseService.getRecentChatMessages(currentUserId, otherUserId,
          quantity: quantity);
}
