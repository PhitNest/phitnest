// ignore_for_file: must_be_immutable

import 'package:flutter/src/widgets/framework.dart';

import '../../../models/models.dart';
import '../screens.dart';
import 'chat_messaging_model.dart';
import 'chat_messaging_view.dart';

class ChatMessagingProvider
    extends ScreenProvider<ChatMessagingModel, ChatMessagingView> {
  final UserModel? user;

  ChatMessagingProvider({Key? key, required this.user}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, ChatMessagingModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    return user != null;
  }

  @override
  ChatMessagingView build(BuildContext context, ChatMessagingModel model) =>
      ChatMessagingView(
        fullName: user?.fullName ?? '',
      );

  @override
  ChatMessagingModel createModel() => ChatMessagingModel();
}
