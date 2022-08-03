import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../screens.dart';
import '../../models/home_model.dart';
import '../../views/home_view.dart';

class ChatHomeProvider extends ScreenProvider<ChatHomeModel, ChatHomeView> {
  const ChatHomeProvider({Key? key}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, ChatHomeModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    model.messageCards =
        Provider.of<HomeModel>(context, listen: false).initialMessageCards;

    return true;
  }

  @override
  ChatHomeView build(BuildContext context, ChatHomeModel model) =>
      ChatHomeView(cards: model.messageCards);

  @override
  ChatHomeModel createModel() => ChatHomeModel();
}
