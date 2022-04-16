import 'package:cached_network_image/cached_network_image.dart';
import 'package:phitnest/constants.dart';
import 'package:phitnest/helpers/helper.dart';
import 'package:phitnest/main.dart';
import 'package:phitnest/model/conversation_model.dart';
import 'package:phitnest/model/home_conversation_model.dart';
import 'package:phitnest/model/user.dart';
import 'package:phitnest/ui/chat/chat_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MatchScreen extends StatefulWidget {
  final User matchedUser;

  MatchScreen({Key? key, required this.matchedUser}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
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
                      SystemChrome.setEnabledSystemUIOverlays(
                          [SystemUiOverlay.bottom, SystemUiOverlay.top]);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'KEEP SWIPING'.tr(),
                      style: TextStyle(
                          fontSize: 16,
                          color: DisplayUtils.isDarkMode(context)
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
                            color: DisplayUtils.isDarkMode(context)
                                ? Colors.black
                                : Colors.white),
                      ),
                      onPressed: () async {
                        String channelID;
                        if (widget.matchedUser.userID
                                .compareTo(PhitnestApp.currentUser!.userID) <
                            0) {
                          channelID = widget.matchedUser.userID +
                              PhitnestApp.currentUser!.userID;
                        } else {
                          channelID = PhitnestApp.currentUser!.userID +
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
