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
  Stream<ChatMessage?> streamChatMessageDocuments(
      String authorId, String recipientId,
      {int quantity = 1}) {
    throw UnimplementedError();
  }
}
