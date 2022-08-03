import '../../../screen_model.dart';
import '../../views/home_view.dart';

class ChatHomeModel extends ScreenModel {
  List<ChatCard> _messageCards = [];

  List<ChatCard> get messageCards => _messageCards;

  set messageCards(List<ChatCard> messageCards) {
    _messageCards = messageCards;
    notifyListeners();
  }
}
