import '../models/models.dart';

abstract class ChatService {
  Future<bool> refreshConnection();

  Future<bool> sendMessage(UserModel from, UserModel to);

  receiveMessageCallback(UserModel from, UserModel to);
}
