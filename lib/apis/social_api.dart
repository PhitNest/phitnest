import '../../models/models.dart';
import 'api.dart';

/// Abstract representation of the social api
abstract class SocialApi extends Api {
  /// Update the given public and private user model in the
  /// database. Returns null on success, or error message.
  Future<String?> updateFullUserModel(UserModel user);

  /// Get the public and private user models for the given uid
  Future<UserModel?> getFullUserModel(String uid);

  /// Streams a users public data
  Stream<UserPublicInfo?> streamUserInfo(String uid);

  /// Stream updates in the conversation between the user and other person
  Stream<List<ChatMessage>> streamMessagesBetweenUsers(
      String userId, String otherUserId,
      {int quantity = 1, bool descending = true});

  /// Stream public user info from the users friends
  Stream<List<UserPublicInfo>> streamFriends(String userId,
      {int quantity = 1, String orderBy = 'timeStamp', bool descending = true});

  /// Stream recent messages from friends
  Stream<Map<UserPublicInfo, ChatMessage>> streamRecentMessagesFromFriends(
    String userId, {
    int quantity = 1,
    bool descending = true,
  });

  /// Updates the read status of a message
  Future<void> updateReadStatus(String messageId, {bool read = true});
}
