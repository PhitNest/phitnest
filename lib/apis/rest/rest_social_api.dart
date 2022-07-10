import '../../models/models.dart';
import '../api.dart';

class RestSocialApiState extends SocialApiState {}

class RestSocialApi extends SocialApi {
  @override
  Stream<UserPublicInfo?> streamUserInfo(String uid) {
    throw UnimplementedError();
  }

  @override
  Stream<List<UserPublicInfo>> streamFriends(String userId,
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
  Stream<List<Conversation>> streamConversations(String userId,
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
  Future<AuthenticatedUser?> refreshSignedInUser() {
    throw UnimplementedError();
  }

  @override
  Future<String?> updateUserModel(AuthenticatedUser user) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Relation>> streamRelations(String userId,
      {int quantity = -1,
      String orderBy = 'timestamp',
      String? type,
      bool descending = true}) {
    throw UnimplementedError();
  }

  @override
  RestSocialApiState get initState => RestSocialApiState();

  @override
  Future<void> sendMessage(
      String authorId, String conversationId, String text) {
    throw UnimplementedError();
  }

  @override
  Future<void> createConversation(List<String> userIds) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMessage(String conversationId, String messageId) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteConversation(String conversationId) {
    throw UnimplementedError();
  }
}
