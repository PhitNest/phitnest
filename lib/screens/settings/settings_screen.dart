import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app.dart';

class SettingsScreen extends StatefulWidget {
  final UserModel user;

  const SettingsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late UserModel user;

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

  ListTile _buildListOption(
      String text, String currentValue, Function() callback) {
    Color color = DisplayUtils.isDarkMode ? Colors.white : Colors.black;
    double fontSize = 17;
    return ListTile(
        title: Text(
          text.tr(),
          style: TextStyle(fontSize: fontSize, color: color),
        ),
        trailing: GestureDetector(
          onTap: callback,
          child: Text(
            currentValue.tr(),
            style: TextStyle(
                fontSize: fontSize, color: color, fontWeight: FontWeight.bold),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: DisplayUtils.isDarkMode ? Colors.white : Colors.black),
        backgroundColor: DisplayUtils.isDarkMode ? Colors.black : Colors.white,
        systemOverlayStyle: DisplayUtils.isDarkMode
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        centerTitle: true,
        title: Text(
          'Settings'.tr(),
          style: TextStyle(
              color: DisplayUtils.isDarkMode ? Colors.white : Colors.black),
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
                            color: DisplayUtils.isDarkMode
                                ? Colors.white54
                                : Colors.black54,
                            fontSize: 18),
                      ),
                    ),
                    Material(
                      elevation: 2,
                      color: DisplayUtils.isDarkMode
                          ? Colors.black12
                          : Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SwitchListTile.adaptive(
                              activeColor: Color(COLOR_ACCENT),
                              title: Text(
                                'Show Me on Flutter phitnest'.tr(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: DisplayUtils.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              value: showMe,
                              onChanged: (bool newValue) {
                                showMe = newValue;
                                setState(() {});
                              }),
                          _buildListOption(
                              'Distance Radius',
                              radius.isNotEmpty ? '$radius Miles' : 'Unlimited',
                              _onDistanceRadiusClick),
                          _buildListOption('Gender', gender, _onGenderClick),
                          _buildListOption('Gender Preference', prefGender,
                              _onGenderPrefClick),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0, left: 16, top: 16, bottom: 8),
                      child: Text(
                        'Push Notifications'.tr(),
                        style: TextStyle(
                            color: DisplayUtils.isDarkMode
                                ? Colors.white54
                                : Colors.black54,
                            fontSize: 18),
                      ),
                    ),
                    Material(
                      elevation: 2,
                      color: DisplayUtils.isDarkMode
                          ? Colors.black12
                          : Colors.white,
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
                                  color: DisplayUtils.isDarkMode
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
                                      color: DisplayUtils.isDarkMode
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
                                      color: DisplayUtils.isDarkMode
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
                                      color: DisplayUtils.isDarkMode
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
                          color: DisplayUtils.isDarkMode
                              ? Colors.black12
                              : Colors.white,
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(12.0),
                            onPressed: () async {
                              DialogUtils.showProgress(
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
                              await BackEndModel.getBackEnd(context)
                                  .updateCurrentUser(user);
                              await DialogUtils.hideProgress();
                              ScaffoldMessenger.of(buildContext).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text(
                                    'Settings saved successfully'.tr(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Save'.tr(),
                              style: TextStyle(
                                  fontSize: 18, color: Color(COLOR_PRIMARY)),
                            ),
                            color: DisplayUtils.isDarkMode
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
