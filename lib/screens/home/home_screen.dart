import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phitnest/screens/home/provider/home_provider.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../constants/constants.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<AppModel>(context, listen: false).currentUser = user;

    if (user.isVip) {
      checkSubscription(context);
    }

    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return HomeScreenProvider(
        user: user,
        builder: (context, state, child) {
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
                  iconSize:
                      state.selection == Selection.Conversations ? 35 : 24,
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

  void checkSubscription(BuildContext context) async {
    await DialogUtils.showProgress(context, 'Loading...', false);
    await FirebaseUtils.isSubscriptionActive(user);
    await DialogUtils.hideProgress();
  }
}
