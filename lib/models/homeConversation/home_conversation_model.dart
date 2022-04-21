import 'package:phitnest/models/models.dart';

class HomeConversationModel {
  bool isGroupChat;

  List<UserModel> members;

  ConversationModel? conversationModel;

  HomeConversationModel(
      {this.isGroupChat = false,
      this.members = const [],
      this.conversationModel});
}
