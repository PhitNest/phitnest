import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:display/display_utils.dart';

import '../../constants/constants.dart';
import '../screen_utils.dart';
import 'functions/home_functions.dart';
import 'provider/home_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeFunctions functions = HomeFunctions(context);
    functions.setUserActive();

    return HomeScreenProvider(builder: (context, state, child) {
      return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () => state.selection = Selection.Swipe,
            child: Image.asset(
              'assets/images/app_logo.png',
              width: state.selection == Selection.Swipe ? 40 : 24,
              height: state.selection == Selection.Swipe ? 40 : 24,
              color: state.selection == Selection.Swipe
                  ? Color(COLOR_PRIMARY)
                  : Colors.grey,
            ),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.person,
                color: state.selection == Selection.Profile
                    ? Color(COLOR_PRIMARY)
                    : Colors.grey,
              ),
              iconSize: state.selection == Selection.Profile ? 35 : 24,
              onPressed: () => state.selection = Selection.Profile),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () => state.selection = Selection.Conversations,
              color: state.selection == Selection.Conversations
                  ? Color(COLOR_PRIMARY)
                  : Colors.grey,
              iconSize: state.selection == Selection.Conversations ? 35 : 24,
            )
          ],
          backgroundColor: Colors.transparent,
          systemOverlayStyle: DisplayUtils.isDarkMode
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(child: state.currentWidget),
      );
    });
  }
}
