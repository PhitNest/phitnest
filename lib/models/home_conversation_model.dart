import 'conversation_model.dart';
import 'user.dart';

class HomeConversationModel {
  bool isGroupChat;

  List<User> members;

  ConversationModel? conversationModel;

  HomeConversationModel(
      {this.isGroupChat = false,
      this.members = const [],
      this.conversationModel});
}
