import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app.dart';

enum Selection { Conversations, Profile, Swipe }

class ScreenState extends ChangeNotifier {
  final UserModel user;

  late final Map<Selection, Widget> _widgets;

  Selection _selection = Selection.Swipe;

  Selection get selection => _selection;

  set selection(Selection selection) {
    _selection = selection;
    notifyListeners();
  }

  Widget get currentWidget => _widgets[_selection]!;

  ScreenState({required this.user}) : super() {
    _widgets = {
      Selection.Swipe: SwipeScreen(user: user),
      Selection.Conversations: ConversationsScreen(user: user),
      Selection.Profile: ProfileScreen(user: user)
    };
  }
}

class HomeScreenProvider extends StatelessWidget {
  final UserModel user;
  final Widget Function(BuildContext context, ScreenState state, Widget? child)
      builder;

  const HomeScreenProvider(
      {Key? key, required this.user, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ScreenState(user: user),
        child: Consumer<ScreenState>(builder: builder));
  }
}
