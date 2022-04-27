import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import '../screen_utils.dart';
import '../screens.dart';
import 'provider/conversations_provider.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConversationsScreenProvider(
        backEnd: BackEndModel.getBackEnd(context),
        user: BackEndModel.getBackEnd(context).currentUser!,
        builder: (context, state, child) {
          return Container(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: FutureBuilder<List<UserModel>>(
                    future: state.matchesFuture,
                    initialData: [],
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting)
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(COLOR_ACCENT)),
                            ),
                          ),
                        );
                      if (!snap.hasData || (snap.data?.isEmpty ?? true)) {
                        return Center(
                          child: Text(
                            'No Matches found.'.tr(),
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snap.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            UserModel friend = snap.data![index];
                            return BackEndModel.getBackEnd(context)
                                    .validateIfUserBlocked(friend.userID)
                                ? Container(
                                    width: 0,
                                    height: 0,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 4, right: 4),
                                    child: InkWell(
                                      onLongPress: () =>
                                          _onMatchLongPress(context, friend),
                                      onTap: () async {
                                        String channelID;
                                        if (friend.userID.compareTo(
                                                BackEndModel.getBackEnd(context)
                                                    .currentUser!
                                                    .userID) <
                                            0) {
                                          channelID = friend.userID +
                                              BackEndModel.getBackEnd(context)
                                                  .currentUser!
                                                  .userID;
                                        } else {
                                          channelID =
                                              BackEndModel.getBackEnd(context)
                                                      .currentUser!
                                                      .userID +
                                                  friend.userID;
                                        }
                                        ConversationModel? conversationModel =
                                            await BackEndModel.getBackEnd(
                                                    context)
                                                .getChannelByIdOrNull(
                                                    channelID);
                                        Navigation.push(
                                            context,
                                            ChatScreen(
                                                user: BackEndModel.getBackEnd(
                                                        context)
                                                    .currentUser!,
                                                homeConversationModel:
                                                    HomeConversationModel(
                                                        isGroupChat: false,
                                                        members: [friend],
                                                        conversationModel:
                                                            conversationModel)));
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          DisplayUtils.displayCircleImage(
                                              friend.profilePictureURL,
                                              50,
                                              false),
                                          Expanded(
                                            child: Container(
                                              width: 75,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 8,
                                                    right: 8),
                                                child: Text(
                                                  '${friend.firstName}',
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                          },
                        );
                      }
                    },
                  ),
                ),
                StreamBuilder<List<HomeConversationModel>>(
                  stream: state.conversationsStream,
                  initialData: [],
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(COLOR_ACCENT)),
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData ||
                        (snapshot.data?.isEmpty ?? true)) {
                      return Center(
                        child: Text(
                          'No Conversations found.'.tr(),
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final homeConversationModel = snapshot.data![index];
                            if (homeConversationModel.isGroupChat) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 8, bottom: 8),
                                child: _buildConversationRow(
                                    context, homeConversationModel),
                              );
                            } else {
                              return BackEndModel.getBackEnd(context)
                                      .validateIfUserBlocked(
                                          homeConversationModel
                                              .members.first.userID)
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16,
                                          top: 8,
                                          bottom: 8),
                                      child: _buildConversationRow(
                                          context, homeConversationModel),
                                    );
                            }
                          });
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Widget _buildConversationRow(
      BuildContext context, HomeConversationModel homeConversationModel) {
    String user1Image = '';
    String user2Image = '';
    if (homeConversationModel.members.length >= 2) {
      user1Image = homeConversationModel.members.first.profilePictureURL;
      user2Image = homeConversationModel.members.elementAt(1).profilePictureURL;
    }
    return homeConversationModel.isGroupChat
        ? Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 12.8),
            child: InkWell(
              onTap: () {
                Navigation.push(
                    context,
                    ChatScreen(
                        user: BackEndModel.getBackEnd(context).currentUser!,
                        homeConversationModel: homeConversationModel));
              },
              child: Row(
                children: <Widget>[
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      DisplayUtils.displayCircleImage(user1Image, 44, false),
                      Positioned(
                          left: -16,
                          bottom: -12.8,
                          child: DisplayUtils.displayCircleImage(
                              user2Image, 44, true))
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8, right: 8, left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${homeConversationModel.conversationModel!.name}',
                            style: TextStyle(
                              fontSize: 17,
                              color: DisplayUtils.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontFamily: Platform.isIOS ? 'sanFran' : 'Roboto',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${homeConversationModel.conversationModel!.lastMessage} • ${TimeUtils.formatTimestamp(homeConversationModel.conversationModel!.lastMessageDate.seconds)}',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xffACACAC)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () {
              Navigation.push(
                  context,
                  ChatScreen(
                      user: BackEndModel.getBackEnd(context).currentUser!,
                      homeConversationModel: homeConversationModel));
            },
            child: Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    DisplayUtils.displayCircleImage(
                        homeConversationModel.members.first.profilePictureURL,
                        60,
                        false),
                    Positioned(
                        right: 2.4,
                        bottom: 2.4,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                              color: homeConversationModel.members.first.active
                                  ? Colors.green
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: DisplayUtils.isDarkMode
                                      ? Color(0xFF303030)
                                      : Colors.white,
                                  width: 1.6)),
                        ))
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8, left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${homeConversationModel.members.first.fullName()}',
                          style: TextStyle(
                              fontSize: 17,
                              color: DisplayUtils.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontFamily:
                                  Platform.isIOS ? 'sanFran' : 'Roboto'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${homeConversationModel.conversationModel?.lastMessage} • ${TimeUtils.formatTimestamp(homeConversationModel.conversationModel?.lastMessageDate.seconds ?? 0)}',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14, color: Color(0xffACACAC)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }

  _onMatchLongPress(BuildContext context, UserModel friend) {
    final action = CupertinoActionSheet(
      message: Text(
        friend.fullName(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('View Profile'.tr()),
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            Navigation.push(context, UserDetailsScreen(isMatch: true));
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
}
