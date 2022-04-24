import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../../models/models.dart';

class ScreenState extends ChangeNotifier {
  final UserModel user;
  late Future<List<UserModel>> matchesFuture;
  late Stream<List<HomeConversationModel>> conversationsStream;

  ScreenState({required this.user}) : super() {
    FirebaseUtils.getBlocks(user).listen((shouldRefresh) {
      if (shouldRefresh) {
        notifyListeners();
      }
    });
    matchesFuture = FirebaseUtils.getMatchedUserObject(user.userID);
    conversationsStream = FirebaseUtils.getConversations(user);
  }
}

class ConversationsScreenProvider extends StatelessWidget {
  final UserModel user;
  final Widget Function(BuildContext context, ScreenState state, Widget? child)
      builder;

  const ConversationsScreenProvider(
      {Key? key, required this.user, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScreenState(user: user),
      child: Consumer<ScreenState>(builder: builder),
    );
  }
}
