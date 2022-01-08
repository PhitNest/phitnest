import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/CustomFlutterTinderCard.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/matchScreen/MatchScreen.dart';
import 'package:dating/ui/upgradeAccount/UpgradeAccount.dart';
import 'package:dating/ui/userDetailsScreen/UserDetailsScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  FireStoreUtils _fireStoreUtils = FireStoreUtils();
  late Stream<List<User>> tinderUsers;
  List<User> swipedUsers = [];
  List<User> users = [];
  CardController controller = CardController();

  @override
  void initState() {
    super.initState();
    _setupTinder();
  }

  @override
  void dispose() {
    _fireStoreUtils.closeTinderStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: tinderUsers,
      initialData: [],
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}'.tr());
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
              ),
            );
          case ConnectionState.active:
            return _asyncCards(context, snapshot.data);
          case ConnectionState.done:
        }
        return Container(); // unreachable
      },
    );
  }

  Widget _buildCard(User tinderUser) {
    return GestureDetector(
      onTap: () async {
        _launchDetailsScreen(tinderUser);
      },
      child: Card(
        child: Stack(
          children: <Widget>[
            Container(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: tinderUser.profilePictureURL == DEFAULT_AVATAR_URL
                        ? ''
                        : tinderUser.profilePictureURL,
                    placeholder: (context, imageUrl) {
                      return Icon(
                        Icons.account_circle,
                        size: MediaQuery.of(context).size.height * .4,
                        color:
                            isDarkMode(context) ? Colors.black : Colors.white,
                      );
                    },
                    errorWidget: (context, imageUrl, error) {
                      return Icon(
                        Icons.account_circle,
                        size: MediaQuery.of(context).size.height * .4,
                        color:
                            isDarkMode(context) ? Colors.black : Colors.white,
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              right: 5,
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                iconSize: 30,
                onPressed: () => _onCardSettingsClick(tinderUser),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(25)),
                    gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black54, Colors.black26])),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          tinderUser.age.isEmpty
                              ? '${tinderUser.fullName()}'
                              : '${tinderUser.fullName()}, ${tinderUser.age}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: tinderUser.school.trim().isNotEmpty,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.school,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '${tinderUser.school}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '${tinderUser.milesAway}',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Visibility(
                visible: swipedUsers.isNotEmpty,
                child: FloatingActionButton(
                  heroTag: '${tinderUser.userID}',
                  backgroundColor: Color(COLOR_PRIMARY),
                  mini: true,
                  child: Icon(
                    Icons.undo,
                    color: Colors.white,
                  ),
                  onPressed: () => _undo(),
                ),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(25),
        ),
        color: Color(COLOR_PRIMARY),
      ),
    );
  }

  Future<void> _launchDetailsScreen(User tinderUser) async {
    CardSwipeOrientation? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(
          user: tinderUser,
          isMatch: false,
        ),
      ),
    );
    if (result != null) {
      if (result == CardSwipeOrientation.LEFT) {
        controller.triggerLeft();
      } else {
        controller.triggerRight();
      }
    }
  }

  _onCardSettingsClick(User user) {
    final action = CupertinoActionSheet(
      message: Text(
        user.fullName(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Block user'.tr()),
          onPressed: () async {
            Navigator.pop(context);
            showProgress(context, 'Blocking user...'.tr(), false);
            bool isSuccessful = await _fireStoreUtils.blockUser(user, 'block');
            hideProgress();
            if (isSuccessful) {
              await _fireStoreUtils.onSwipeLeft(user);
              users.remove(user);
              _fireStoreUtils.updateCardStream(users);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user.fullName()} has been blocked.'.tr()),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Couldn\'t block ${user.fullName()}, please try again later.'
                          .tr()),
                ),
              );
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Report user'.tr()),
          onPressed: () async {
            Navigator.pop(context);
            showProgress(context, 'Reporting user...'.tr(), false);
            bool isSuccessful = await _fireStoreUtils.blockUser(user, 'report');
            hideProgress();
            if (isSuccessful) {
              await _fireStoreUtils.onSwipeLeft(user);
              users.removeWhere((element) => element.userID == user.userID);
              _fireStoreUtils.updateCardStream(users);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${user.fullName()} has been reported and blocked.'.tr()),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Couldn\'t report ${user.fullName()}, please try again later.'
                          .tr()),
                ),
              );
            }
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel'.tr(),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  _undo() async {
    if (MyAppState.currentUser!.isVip) {
      User undoUser = swipedUsers.removeLast();
      users.insert(0, undoUser);
      _fireStoreUtils.updateCardStream(users);
      await _fireStoreUtils.undo(undoUser);
    } else {
      _showUpgradeAccountDialog();
    }
  }

  Widget _asyncCards(BuildContext context, List<User>? data) {
    users = data ?? [];
    if (data == null || data.isEmpty)
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'There’s no one around you. Try increasing the distance radius to get more recommendations.'
                .tr(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Stack(children: [
              Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'There’s no one around you. Try increasing '
                              'the distance radius to get more recommendations.'
                          .tr(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                child: TinderSwapCard(
                  animDuration: 500,
                  orientation: AmassOrientation.BOTTOM,
                  totalNum: data.length,
                  stackNum: 3,
                  swipeEdge: 15,
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height,
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  minHeight: MediaQuery.of(context).size.height * 0.9,
                  cardBuilder: (context, index) => _buildCard(data[index]),
                  cardController: controller,
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) async {
                    if (orientation == CardSwipeOrientation.LEFT ||
                        orientation == CardSwipeOrientation.RIGHT) {
                      bool isValidSwipe = MyAppState.currentUser!.isVip
                          ? true
                          : await _fireStoreUtils.incrementSwipe();
                      if (isValidSwipe) {
                        if (orientation == CardSwipeOrientation.RIGHT) {
                          User? result =
                              await _fireStoreUtils.onSwipeRight(data[index]);
                          if (result != null) {
                            data.removeAt(index);
                            _fireStoreUtils.updateCardStream(data);
                            push(context, MatchScreen(matchedUser: result));
                          } else {
                            swipedUsers.add(data[index]);
                            data.removeAt(index);
                            _fireStoreUtils.updateCardStream(data);
                          }
                        } else if (orientation == CardSwipeOrientation.LEFT) {
                          swipedUsers.add(data[index]);
                          await _fireStoreUtils.onSwipeLeft(data[index]);
                          data.removeAt(index);
                          _fireStoreUtils.updateCardStream(data);
                        }
                      } else {
                        User returningUser = data.removeAt(index);
                        _fireStoreUtils.updateCardStream(data);
                        _showUpgradeAccountDialog();
                        await Future.delayed(Duration(milliseconds: 200));
                        data.insert(0, returningUser);
                        _fireStoreUtils.updateCardStream(data);
                      }
                    }
                  },
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  elevation: 1,
                  heroTag: 'left'.tr(),
                  onPressed: () {
                    controller.triggerLeft();
                  },
                  backgroundColor: Colors.white,
                  mini: false,
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                FloatingActionButton(
                  elevation: 1,
                  heroTag: 'center'.tr(),
                  onPressed: () {
                    controller.triggerRight();
                  },
                  backgroundColor: Colors.white,
                  mini: true,
                  child: Icon(
                    Icons.star,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                FloatingActionButton(
                  elevation: 1,
                  heroTag: 'right'.tr(),
                  onPressed: () {
                    controller.triggerRight();
                  },
                  backgroundColor: Colors.white,
                  mini: false,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.green,
                    size: 40,
                  ),
                )
              ],
            ),
          )
        ]);
  }

  void _showUpgradeAccountDialog() {
    if (Platform.isAndroid) {
      Widget okButton = TextButton(
        child: Text('OK'.tr()),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget upgradeButton = TextButton(
        child: Text('Upgrade Now'.tr()),
        onPressed: () {
          Navigator.pop(context);
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (context) {
              return UpgradeAccount();
            },
          );
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text('Upgrade account'.tr()),
        content: Text('Upgrade your account now to have unlimited swipes per '
                'day and the ability to undo a swipe.'
            .tr()),
        actions: [upgradeButton, okButton],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      Widget okButton = TextButton(
        child: Text('OK'.tr()),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget upgradeButton = TextButton(
        child: Text('Upgrade Now'.tr()),
        onPressed: () {
          Navigator.pop(context);
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (context) {
              return UpgradeAccount();
            },
          );
        },
      );
      CupertinoAlertDialog alert = CupertinoAlertDialog(
        title: Text('Upgrade account'.tr()),
        content: Text('Upgrade your account now to have unlimited swipes per '
                'day and the ability to undo a swipe.'
            .tr()),
        actions: [upgradeButton, okButton],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  _setupTinder() async {
    tinderUsers = _fireStoreUtils.getTinderUsers();
    await _fireStoreUtils.matchChecker(context);
  }
}
