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

  /// Streams a users public data, or null if the user is deleted.
  Stream<UserPublicInfo?> streamUserInfo(String uid);

  /// Streams all messages in a conversation
  Stream<List<ChatMessage>> streamMessages(String userId, String conversationId,
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
