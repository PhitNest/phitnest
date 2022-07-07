import '../../models/models.dart';
import '../api.dart';

class RestSocialApi extends SocialApi {
  @override
  Future<UserModel?> getFullUserModel(String uid) {
    throw UnimplementedError();
  }

  @override
  Future<String?> updateFullUserModel(UserModel user) {
    throw UnimplementedError();
  }

  @override
  Stream<UserPublicInfo?> streamUserInfo(String uid) {
    throw UnimplementedError();
  }

  @override
  Stream<List<ChatMessage>> streamMessagesBetweenUsers(
    String userId,
    String otherUserId, {
    int quantity = 1,
    bool descending = true,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<UserPublicInfo>> streamFriends(String userId,
      {int quantity = 1,
      String orderBy = 'timeStamp',
      bool descending = true}) {
    throw UnimplementedError();
  }

  @override
  Stream<Map<UserPublicInfo, ChatMessage>> streamRecentMessagesFromFriends(
      String userId,
      {int quantity = 1,
      bool descending = true}) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateReadStatus(String messageId, {bool read = true}) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserLocation(String uid, Location location) {
    throw UnimplementedError();
  }
}
