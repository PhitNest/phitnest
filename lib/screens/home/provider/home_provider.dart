import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app.dart';

enum Selection { Conversations, Profile, Swipe }

class ScreenState extends ChangeNotifier {
  late final Map<Selection, Widget> _widgets;

  Selection _selection = Selection.Swipe;

  Selection get selection => _selection;

  set selection(Selection selection) {
    _selection = selection;
    notifyListeners();
  }

  Widget get currentWidget => _widgets[_selection]!;

  ScreenState() : super() {
    _widgets = {
      Selection.Swipe: SwipeScreen(),
      Selection.Conversations: ConversationsScreen(),
      Selection.Profile: ProfileScreen()
    };
  }
}

class HomeScreenProvider extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenState state, Widget? child)
      builder;

  const HomeScreenProvider({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ScreenState(),
        child: Consumer<ScreenState>(builder: builder));
  }
}
