import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:display/display_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:phitnest/services/backend_model.dart';

import '../../../../models/models.dart';
import '../../../../widgets/widgets.dart';
import '../../../screen_utils.dart';
import '../../../screens.dart';
import 'swipe_model.dart';

class SwipeFunctions {
  late final BackEndModel _backEnd;
  final BuildContext context;
  final SwipeModel model;

  SwipeFunctions({required this.context, required this.model}) {
    _backEnd = BackEndModel.getBackEnd(context);
    _setupTinder();
  }

  Widget _buildCard(UserModel tinderUser) {
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
                        color: DisplayUtils.isDarkMode
                            ? Colors.black
                            : Colors.white,
                      );
                    },
                    errorWidget: (context, imageUrl, error) {
                      return Icon(
                        Icons.account_circle,
                        size: MediaQuery.of(context).size.height * .4,
                        color: DisplayUtils.isDarkMode
                            ? Colors.black
                            : Colors.white,
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
                visible: model.swipedUsers.isNotEmpty,
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

  Future<void> _launchDetailsScreen(UserModel tinderUser) async {
    CardSwipeOrientation? result = await Navigation.push(
        context, UserDetailsScreen(viewingUser: tinderUser, isMatch: false));
    if (result != null) {
      if (result == CardSwipeOrientation.LEFT) {
        model.controller.triggerLeft();
      } else {
        model.controller.triggerRight();
      }
    }
  }

  _onCardSettingsClick(UserModel other) {
    final action = CupertinoActionSheet(
      message: Text(
        other.fullName(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Block user'),
          onPressed: () async {
            Navigator.pop(context);
            await DialogUtils.showProgress(context, 'Blocking user...', false);
            bool isSuccessful = await _backEnd.blockUser(other, 'block');
            await DialogUtils.hideProgress();
            if (isSuccessful) {
              await _backEnd.onSwipeLeft(other);
              model.users.remove(other);
              model.tinderCardsStreamController.add(model.users);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${other.fullName()} has been blocked.'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Couldn\'t block ${other.fullName()}, please try again later.'),
                ),
              );
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Report user'),
          onPressed: () async {
            Navigator.pop(context);
            DialogUtils.showProgress(context, 'Reporting user...', false);
            bool isSuccessful = await _backEnd.blockUser(other, 'report');
            DialogUtils.hideProgress();
            if (isSuccessful) {
              await _backEnd.onSwipeLeft(other);
              model.users
                  .removeWhere((element) => element.userID == other.userID);
              model.tinderCardsStreamController.add(model.users);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${other.fullName()} has been reported and blocked.'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Couldn\'t report ${other.fullName()}, please try again later.'),
                ),
              );
            }
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel',
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  _undo() async {
    if (_backEnd.currentUser!.isVip) {
      UserModel undoUser = model.swipedUsers.removeLast();
      model.users.insert(0, undoUser);
      model.tinderCardsStreamController.add(model.users);
      await _backEnd.undo(undoUser);
    } else {
      _showUpgradeAccountDialog();
    }
  }

  Widget asyncCards(BuildContext context, List<UserModel>? data) {
    model.users = data ?? [];
    if (data == null || data.isEmpty)
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'There’s no one around you. Try increasing the distance radius to get more recommendations.',
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
                      'the distance radius to get more recommendations.',
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
                  cardController: model.controller,
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) async {
                    if (orientation == CardSwipeOrientation.LEFT ||
                        orientation == CardSwipeOrientation.RIGHT) {
                      bool isValidSwipe = _backEnd.currentUser!.isVip
                          ? true
                          : await _backEnd.incrementSwipe();
                      if (isValidSwipe) {
                        if (orientation == CardSwipeOrientation.RIGHT) {
                          UserModel? result =
                              await _backEnd.onSwipeRight(data[index]);
                          if (result != null) {
                            data.removeAt(index);
                            model.tinderCardsStreamController.add(data);
                            Navigation.push(
                                context,
                                MatchScreen(
                                    user: _backEnd.currentUser!,
                                    matchedUser: result));
                          } else {
                            model.swipedUsers.add(data[index]);
                            data.removeAt(index);
                            model.tinderCardsStreamController.add(data);
                          }
                        } else if (orientation == CardSwipeOrientation.LEFT) {
                          model.swipedUsers.add(data[index]);
                          await _backEnd.onSwipeLeft(data[index]);
                          data.removeAt(index);
                          model.tinderCardsStreamController.add(data);
                        }
                      } else {
                        UserModel returningUser = data.removeAt(index);
                        model.tinderCardsStreamController.add(data);

                        _showUpgradeAccountDialog();
                        await Future.delayed(Duration(milliseconds: 200));
                        data.insert(0, returningUser);
                        model.tinderCardsStreamController.add(data);
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
                  heroTag: 'left',
                  onPressed: () {
                    model.controller.triggerLeft();
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
                  heroTag: 'center',
                  onPressed: () {
                    model.controller.triggerRight();
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
                  heroTag: 'right',
                  onPressed: () {
                    model.controller.triggerRight();
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
        child: Text('OK'),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget upgradeButton = TextButton(
        child: Text('Upgrade Now'),
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
        title: Text('Upgrade account'),
        content: Text('Upgrade your account now to have unlimited swipes per '
            'day and the ability to undo a swipe.'),
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
        child: Text('OK'),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget upgradeButton = TextButton(
        child: Text('Upgrade Now'),
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
        title: Text('Upgrade account'),
        content: Text('Upgrade your account now to have unlimited swipes per '
            'day and the ability to undo a swipe.'),
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
    model.tinderCardsStreamController = StreamController<List<UserModel>>();
    model.tinderUsers =
        _backEnd.getTinderUsers(model.tinderCardsStreamController);
    await _backEnd.matchChecker(context, (user) {
      Navigation.push(
          context, MatchScreen(user: _backEnd.currentUser!, matchedUser: user));
    });
  }
}
