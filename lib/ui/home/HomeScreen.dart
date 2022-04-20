import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/SwipeScreen/SwipeScreen.dart';
import 'package:dating/ui/conversationsScreen/ConversationsScreen.dart';
import 'package:dating/ui/profile/ProfileScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum DrawerSelection { Conversations, Contacts, Search, Profile }

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  late User user;
  String _appBarTitle = 'Swipe'.tr();
  late Widget _currentWidget;

  @override
  void initState() {
    super.initState();
    if (MyAppState.currentUser!.isVip) {
      checkSubscription();
    }
    user = widget.user;
    _currentWidget = SwipeScreen();
    FireStoreUtils.firebaseMessaging.requestPermission(
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
      child: Consumer<User>(
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
              brightness:
                  isDarkMode(context) ? Brightness.dark : Brightness.light,
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
    await showProgress(context, 'Loading...', false);
    await FireStoreUtils.isSubscriptionActive();
    await hideProgress();
  }
}
