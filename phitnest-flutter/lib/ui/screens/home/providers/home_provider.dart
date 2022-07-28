import 'package:flutter/material.dart';

import '../../../../apis/apis.dart';
import '../../screens.dart';
import '../models/home_model.dart';
import '../views/home_view.dart';

export 'chatHome/chat_home_provider.dart';
export 'profile/profile_provider.dart';

class HomeProvider extends AuthenticatedProvider<HomeModel, HomeView> {
  const HomeProvider({Key? key}) : super(key: key);

  /// If this returns true, the loading widget is dropped. If it returns false,
  /// the loading widget stays until we navigate away from the screen.
  /// If updating location, updating ip, and updating activity status all
  /// succeed, drop the loading screen. Otherwise
  @override
  init(BuildContext context, HomeModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    StreamApi.instance.refreshWebSocket();

    model.currentUser =
        await DatabaseApi.instance.getPublicInfo(AuthApi.instance.userId!);

    model.messageCards = (await DatabaseApi.instance.getRecentConversations())
        .map((entry) => ChatCard(
            message: entry.value.message,
            read: entry.value.readBy.length > 0,
            online: true,
            name: 'test',
            onDismissConfirm: (direction) {},
            onTap: () =>
                Navigator.pushNamed(context, '/chat', arguments: entry.key)))
        .toList();

    return true;
  }

  @override
  HomeView build(BuildContext context, HomeModel model) => HomeView(
        pageController: model.pageController,
        messageCards: model.messageCards,
        currentUser: model.currentUser,
      );

  @override
  HomeModel createModel() => HomeModel();
}
