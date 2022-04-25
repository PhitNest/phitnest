import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app.dart';

class ScreenState extends ChangeNotifier {
  final UserModel user;
  late Future<List<UserModel>> matchesFuture;
  late Stream<List<HomeConversationModel>> conversationsStream;

  ScreenState({required this.user, required BackEndModel backEnd}) : super() {
    backEnd.getBlocks().listen((shouldRefresh) {
      if (shouldRefresh) {
        notifyListeners();
      }
    });
    matchesFuture = backEnd.getMatchedUserObject();
    conversationsStream = backEnd.getConversations();
  }
}

class ConversationsScreenProvider extends StatelessWidget {
  final UserModel user;
  final BackEndModel backEnd;
  final Widget Function(BuildContext context, ScreenState state, Widget? child)
      builder;

  const ConversationsScreenProvider(
      {Key? key,
      required this.user,
      required this.backEnd,
      required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScreenState(user: user, backEnd: backEnd),
      child: Consumer<ScreenState>(builder: builder),
    );
  }
}
