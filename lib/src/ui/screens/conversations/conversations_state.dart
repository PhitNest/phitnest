import 'package:dartz/dartz.dart';

import '../../../entities/entities.dart';
import '../state.dart';

class ConversationsState extends ScreenState {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    rebuildView();
  }

  bool _loading = true;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    rebuildView();
  }

  List<FriendEntity> _friends = [];

  List<FriendEntity> get friends => _friends;

  set friends(List<FriendEntity> friends) {
    _friends = friends;
    rebuildView();
  }

  void removeFriend(int index) {
    _friends.removeAt(index);
    rebuildView();
  }

  List<Tuple2<ConversationEntity, MessageEntity>> _conversations = [];

  List<Tuple2<ConversationEntity, MessageEntity>> get conversations =>
      _conversations;

  set conversations(
      List<Tuple2<ConversationEntity, MessageEntity>> conversations) {
    _conversations = conversations;
    rebuildView();
  }

  void removeConversation(int index) {
    _conversations.removeAt(index);
    rebuildView();
  }
}
