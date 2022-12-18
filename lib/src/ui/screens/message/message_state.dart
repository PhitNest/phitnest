import 'package:flutter/cupertino.dart';

import '../../../entities/entities.dart';
import '../state.dart';

class MessageState extends ScreenState {
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  late final FocusNode messageFocus = FocusNode()
    ..addListener(
      () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeInOut,
          );
        }
      },
    );

  void addMessage(MessageEntity message) {
    if (_messages != null) {
      _messages!.insert(0, message);
      rebuildView();
    }
  }

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    rebuildView();
  }

  ConversationEntity? _conversation;

  ConversationEntity? get conversation => _conversation;

  set conversation(ConversationEntity? conversation) {
    _conversation = conversation;
    rebuildView();
  }

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    rebuildView();
  }

  List<MessageEntity>? _messages;

  List<MessageEntity>? get messages => _messages;

  set messages(List<MessageEntity>? messages) {
    _messages = messages;
    rebuildView();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
