import '../state.dart';
import 'models/conversation.dart';

class ConversationsState extends ScreenState {
  List<ConversationModel> _conversations = [
    ConversationModel(
        name: "Priscilla H.",
        recentMessage:
            "I’m an occupational therapist... I can help you with that!"),
    ConversationModel(
        name: "Random Name",
        recentMessage:
            "I’m not an occupational therapist... I can't help you with that!"),
    ConversationModel(
        name: "John S.",
        recentMessage:
            "I’m also not an occupational therapist... But maybe I can help you with that?"),
  ];

  List<ConversationModel> get conversations => _conversations;

  selectConversation(int index, bool selected) {
    conversations[index].selected = selected;
    notifyListeners();
  }
}
