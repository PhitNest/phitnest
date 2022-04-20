import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsScreen extends StatefulWidget {
  final User user;

  const SettingsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late User user;

  late bool showMe, newMatches, messages, superLikes, topPicks;

  late String radius, gender, prefGender;

  @override
  void initState() {
    user = widget.user;
    showMe = user.showMe;
    newMatches = user.settings.pushNewMatchesEnabled;
    messages = user.settings.pushNewMessages;
    superLikes = user.settings.pushSuperLikesEnabled;
    topPicks = user.settings.pushTopPicksEnabled;
    radius = user.settings.distanceRadius;
    gender = user.settings.gender;
    prefGender = user.settings.genderPreference;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: isDarkMode(context) ? Colors.white : Colors.black),
        backgroundColor: isDarkMode(context) ? Colors.black : Colors.white,
        brightness: isDarkMode(context) ? Brightness.dark : Brightness.light,
        centerTitle: true,
        title: Text(
          'Settings'.tr(),
          style: TextStyle(
              color: isDarkMode(context) ? Colors.white : Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Builder(
            builder: (buildContext) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0, left: 16, top: 16, bottom: 8),
                      child: Text(
                        'Discovery'.tr(),
                        style: TextStyle(
                            color: isDarkMode(context)
                                ? Colors.white54
                                : Colors.black54,
                            fontSize: 18),
                      ),
                    ),
                    Material(
                      elevation: 2,
                      color:
                          isDarkMode(context) ? Colors.black12 : Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SwitchListTile.adaptive(
                              activeColor: Color(COLOR_ACCENT),
                              title: Text(
                                'Show Me on Flutter Dating'.tr(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              value: showMe,
                              onChanged: (bool newValue) {
                                showMe = newValue;
                                setState(() {});
                              }),
                          ListTile(
                            title: Text(
                              'Distance Radius'.tr(),
                              style: TextStyle(
                                fontSize: 17,
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: _onDistanceRadiusClick,
                              child: Text(
                                  radius.isNotEmpty
                                      ? '$radius Miles'.tr()
                                      : 'Unlimited'.tr(),
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: isDarkMode(context)
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Gender'.tr(),
                              style: TextStyle(
                                fontSize: 17,
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: _onGenderClick,
                              child: Text('$gender'.tr(),
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: isDarkMode(context)
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Gender Preference'.tr(),
                              style: TextStyle(
                                fontSize: 17,
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: _onGenderPrefClick,
                              child: Text('$prefGender'.tr(),
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: isDarkMode(context)
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0, left: 16, top: 16, bottom: 8),
                      child: Text(
                        'Push Notifications'.tr(),
                        style: TextStyle(
                            color: isDarkMode(context)
                                ? Colors.white54
                                : Colors.black54,
                            fontSize: 18),
                      ),
                    ),
                    Material(
                      elevation: 2,
                      color:
                          isDarkMode(context) ? Colors.black12 : Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SwitchListTile.adaptive(
                              activeColor: Color(COLOR_ACCENT),
                              title: Text(
                                'New matches'.tr(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              value: newMatches,
                              onChanged: (bool newValue) {
                                newMatches = newValue;
                                setState(() {});
                              }),
                          Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: SwitchListTile.adaptive(
                                  activeColor: Color(COLOR_ACCENT),
                                  title: Text(
                                    'Messages'.tr(),
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: isDarkMode(context)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  value: messages,
                                  onChanged: (bool newValue) {
                                    messages = newValue;
                                    setState(() {});
                                  })),
                          Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: SwitchListTile.adaptive(
                                  activeColor: Color(COLOR_ACCENT),
                                  title: Text(
                                    'Super Likes'.tr(),
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: isDarkMode(context)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  value: superLikes,
                                  onChanged: (bool newValue) {
                                    superLikes = newValue;
                                    setState(() {});
                                  })),
                          Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: SwitchListTile.adaptive(
                                  activeColor: Color(COLOR_ACCENT),
                                  title: Text(
                                    'Top Picks'.tr(),
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: isDarkMode(context)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  value: topPicks,
                                  onChanged: (bool newValue) {
                                    topPicks = newValue;
                                    setState(() {});
                                  })),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0, bottom: 16),
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: double.infinity),
                        child: Material(
                          elevation: 2,
                          color: isDarkMode(context)
                              ? Colors.black12
                              : Colors.white,
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(12.0),
                            onPressed: () async {
                              showProgress(
                                  context, 'Saving changes...'.tr(), true);
                              user.settings.genderPreference = prefGender;
                              user.settings.gender = gender;
                              user.settings.showMe = showMe;
                              user.showMe = showMe;
                              user.settings.pushTopPicksEnabled = topPicks;
                              user.settings.pushNewMessages = messages;
                              user.settings.pushSuperLikesEnabled = superLikes;
                              user.settings.pushNewMatchesEnabled = newMatches;
                              user.settings.distanceRadius = radius;
                              User? updateUser =
                                  await FireStoreUtils.updateCurrentUser(user);
                              hideProgress();
                              if (updateUser != null) {
                                this.user = updateUser;
                                MyAppState.currentUser = user;
                                ScaffoldMessenger.of(buildContext).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      'Settings saved successfully'.tr(),
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Save'.tr(),
                              style: TextStyle(
                                  fontSize: 18, color: Color(COLOR_PRIMARY)),
                            ),
                            color: isDarkMode(context)
                                ? Colors.black12
                                : Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
      ),
    );
  }

  _onDistanceRadiusClick() {
    final action = CupertinoActionSheet(
      message: Text(
        'Distance Radius'.tr(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('5 Miles'.tr()),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '5';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('10 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '10';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('15 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '15';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('20 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '20';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('25 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '25';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('50 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '50';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('100 Miles'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '100';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Unlimited'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '';
            setState(() {});
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'.tr()),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  _onGenderClick() {
    final action = CupertinoActionSheet(
      message: Text(
        'Gender'.tr(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Female'.tr()),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            gender = 'Female';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Male'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            gender = 'Male';
            setState(() {});
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'.tr()),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  _onGenderPrefClick() {
    final action = CupertinoActionSheet(
      message: Text(
        'Gender Preference'.tr(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Female'.tr()),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            prefGender = 'Female';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Male'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            prefGender = 'Male';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text('All'.tr()),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            prefGender = 'All';
            setState(() {});
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'.tr()),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}
