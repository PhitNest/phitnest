import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:phitnest/constants/constants.dart';
import 'package:phitnest/helpers/helpers.dart';
import 'package:phitnest/models/models.dart';
import 'package:phitnest/screens/screens.dart';

enum DrawerSelection { Conversations, Contacts, Search, Profile }

class HomeScreen extends StatefulWidget {
  final UserModel user;

  HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  late UserModel user;
  String _appBarTitle = 'Swipe'.tr();
  late Widget _currentWidget;

  @override
  void initState() {
    super.initState();
    if (UserModel.currentUser!.isVip) {
      checkSubscription();
    }
    user = widget.user;
    _currentWidget = SwipeScreen();
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: user,
      child: Consumer<UserModel>(
        builder: (context, user, _) {
          return Scaffold(
            appBar: AppBar(
              title: GestureDetector(
                onTap: () {
                  setState(() {
                    _appBarTitle = 'Swipe'.tr();
                    _currentWidget = SwipeScreen();
                  });
                },
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: _appBarTitle == 'Swipe'.tr() ? 40 : 24,
                  height: _appBarTitle == 'Swipe'.tr() ? 40 : 24,
                  color: _appBarTitle == 'Swipe'.tr()
                      ? Color(COLOR_PRIMARY)
                      : Colors.grey,
                ),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.person,
                    color: _appBarTitle == 'Profile'.tr()
                        ? Color(COLOR_PRIMARY)
                        : Colors.grey,
                  ),
                  iconSize: _appBarTitle == 'Profile'.tr() ? 35 : 24,
                  onPressed: () {
                    setState(() {
                      _appBarTitle = 'Profile'.tr();
                      _currentWidget = ProfileScreen(user: user);
                    });
                  }),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {
                    setState(() {
                      _appBarTitle = 'Conversations'.tr();
                      _currentWidget = ConversationsScreen(user: user);
                    });
                  },
                  color: _appBarTitle == 'Conversations'.tr()
                      ? Color(COLOR_PRIMARY)
                      : Colors.grey,
                  iconSize: _appBarTitle == 'Conversations'.tr() ? 35 : 24,
                )
              ],
              backgroundColor: Colors.transparent,
              systemOverlayStyle: DisplayUtils.isDarkMode(context)
                  ? SystemUiOverlayStyle.dark
                  : SystemUiOverlayStyle.light,
              centerTitle: true,
              elevation: 0,
            ),
            body: SafeArea(child: _currentWidget),
          );
        },
      ),
    );
  }

  void checkSubscription() async {
    await DialogUtils.showProgress(context, 'Loading...', false);
    await FirebaseUtils.isSubscriptionActive();
    await DialogUtils.hideProgress();
  }
}
