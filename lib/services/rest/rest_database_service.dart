import '../../models/models.dart';
import '../services.dart';

class DatabaseServiceImpl extends DatabaseService {
  @override
  Stream<UserPublicInfo?> getAllUsers() async* {
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> getFullUserModel(String uid) {
    throw UnimplementedError();
  }

  @override
  Future<String?> updateFullUserModel(UserModel user) {
    throw UnimplementedError();
  }

  @override
  Stream<ChatMessage?> getRecentChatMessages(
      String authorId, String recipientId,
      {int quantity = 1}) {
    throw UnimplementedError();
  }

  @override
  Stream<ChatMessage?> getChatMessageUpdates(
      String authorId, String recipientId) {
    throw UnimplementedError();
  }

  @override
  Stream<ChatMessage?> getRecentChatMessagesFromAuthor(
      String authorId, String recipientId,
      {int quantity = 1}) {
    throw UnimplementedError();
  }
}
