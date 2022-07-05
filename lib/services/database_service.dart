import '../../models/models.dart';

/// Abstract representation of the database service
abstract class DatabaseService {
  /// Update the given public and private user model in the
  /// database. Returns null on success, or error message.
  Future<String?> updateFullUserModel(UserModel user);

  /// Get the public and private user models for the given uid
  Future<UserModel?> getFullUserModel(String uid);

  /// Streams all public user data
  Stream<UserPublicInfo?> getAllUsers();

  /// Listens for new chat messages between users
  Stream<ChatMessage?> getChatMessageUpdates(
      String authorId, String recipientId);

  /// Streams all chat messages from one user to another sorted by most recent
  Stream<ChatMessage?> getRecentChatMessagesFromAuthor(
      String authorId, String recipientId,
      {int quantity = 1});

  /// Gets all chat messages between two users
  Stream<ChatMessage?> getRecentChatMessages(String userId, String otherUserId,
      {int quantity = 1});
}
