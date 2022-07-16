import '../../models/models.dart';
import 'api.dart';

abstract class SocialApiState extends ApiState {}

/// Abstract representation of the social api
abstract class SocialApi extends Api<SocialApiState> {
  /// Update the authenticated user model in the database. Return an error
  /// message on failure.
  Future<String?> updateUserModel(AuthenticatedUser user);

  /// Get the public and private user models for the signed in user. Returns
  /// null if the user is not signed in or their model does not exist.
  Future<AuthenticatedUser?> refreshSignedInUser();

  /// Delete a message from a conversation.
  Future<void> deleteMessage(String conversationId, String messageId);

  /// Deletes a conversation.
  Future<void> deleteConversation(String conversationId);

  /// Creates a new conversation between a list of users
  Future<void> createConversation(List<String> userIds);

  /// Sends a chat message to a conversation, and updates the timestamp of the conversation.
  Future<void> sendMessage(String authorId, String conversationId, String text);

  /// Streams a users public data, or null if the user is deleted.
  Stream<UserPublicInfo?> streamUserInfo(String uid);

  /// Stream the currently signed in users model. This will throw an exception if the user is not
  /// signed in with the uid provided.
  Stream<AuthenticatedUser> streamSignedInUser(String uid);

  /// Streams all messages in a conversation
  Stream<List<ChatMessage>> streamMessages(String conversationId,
      {int quantity = -1,
      String orderBy = 'timestamp',
      bool descending = true});

  /// Streams all friends of the signed in user
  Stream<List<UserPublicInfo>> streamFriends(String userId,
      {int quantity = -1,
      String orderBy = 'timestamp',
      bool descending = true});

  /// Streams all conversations for the signed in user
  Stream<List<Conversation>> streamConversations(String userId,
      {int quantity = -1,
      String orderBy = 'timestamp',
      bool descending = true});

  /// Updates the read status of a message
  Future<void> updateReadStatus(
      {required String conversationId,
      required String messageId,
      bool read = true});

  /// Streams all user relations authored by the signed in user
  Stream<List<Relation>> streamRelations(String userId,
      {int quantity = -1,
      String orderBy = 'timestamp',
      String? type,
      bool descending = true});
}
