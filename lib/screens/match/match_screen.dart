import 'package:cached_network_image/cached_network_image.dart';
import 'package:phitnest/screens/chat/chat_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:phitnest/constants/constants.dart';
import 'package:phitnest/helpers/helpers.dart';
import 'package:phitnest/models/models.dart';
import 'package:phitnest/screens/screens.dart';

class MatchScreen extends StatefulWidget {
  final UserModel matchedUser;

  MatchScreen({Key? key, required this.matchedUser}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.matchedUser.profilePictureURL,
            errorWidget: (context, url, error) => Image.network(
              DEFAULT_AVATAR_URL,
              fit: BoxFit.cover,
            ),
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.edgeToEdge);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'KEEP SWIPING'.tr(),
                      style: TextStyle(
                          fontSize: 16,
                          color: DisplayUtils.isDarkMode
                              ? Colors.black
                              : Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide.none),
                        primary: Color(COLOR_PRIMARY),
                      ),
                      child: Text(
                        'SEND A MESSAGE'.tr(),
                        style: TextStyle(
                            fontSize: 17,
                            color: DisplayUtils.isDarkMode
                                ? Colors.black
                                : Colors.white),
                      ),
                      onPressed: () async {
                        String channelID;
                        if (widget.matchedUser.userID
                                .compareTo(UserModel.currentUser!.userID) <
                            0) {
                          channelID = widget.matchedUser.userID +
                              UserModel.currentUser!.userID;
                        } else {
                          channelID = UserModel.currentUser!.userID +
                              widget.matchedUser.userID;
                        }
                        ConversationModel? conversationModel =
                            await FirebaseUtils.getChannelByIdOrNull(channelID);
                        NavigationUtils.pushReplacement(
                          context,
                          ChatScreen(
                            homeConversationModel: HomeConversationModel(
                                isGroupChat: false,
                                members: [widget.matchedUser],
                                conversationModel: conversationModel),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 60.0, horizontal: 16),
                  child: Text(
                    'IT\'S A MATCH!'.tr(),
                    style: TextStyle(
                      letterSpacing: 4,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
