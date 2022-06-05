import '../../models/models.dart';
import '../services.dart';

class FirebaseChatService extends ChatService {
  Future<bool> refreshConnection() async {
    return false;
  }

  Future<bool> sendMessage(UserModel from, UserModel to) async {
    return false;
  }

  receiveMessageCallback(UserModel from, UserModel to) {}
}
