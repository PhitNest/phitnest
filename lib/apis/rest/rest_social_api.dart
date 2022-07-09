import '../../models/models.dart';
import '../api.dart';

class RestSocialApi extends SocialApi {
  @override
  Stream<UserPublicInfo?> streamUserInfo(String uid) {
    throw UnimplementedError();
  }

  @override
  Stream<List<UserPublicInfo>> streamFriends(
      {int quantity = 1,
      String orderBy = 'timestamp',
      bool descending = true}) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateReadStatus(
      {required String conversationId,
      required String messageId,
      bool read = true}) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Conversation>> streamConversations(
      {int quantity = 1,
      String orderBy = 'timestamp',
      bool descending = true}) {
    throw UnimplementedError();
  }

  @override
  Stream<List<ChatMessage>> streamMessages(String conversationId,
      {int quantity = 1,
      String orderBy = 'timestamp',
      bool descending = true}) {
    throw UnimplementedError();
  }

  @override
  Future<AuthenticatedUser?> getSignedInUser() {
    throw UnimplementedError();
  }

  @override
  Future<String?> updateUserModel(AuthenticatedUser user) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Relation>> streamRelations(
      {int quantity = -1,
      String orderBy = 'timestamp',
      String? type,
      bool descending = true}) {
    throw UnimplementedError();
  }
}
