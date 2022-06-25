import 'package:flutter/material.dart';

import '../../../base_provider.dart';
import 'chat_card_model.dart';
import 'chat_card_view.dart';

class ChatCardProvider extends BaseProvider<ChatCardModel, ChatCardView> {
  final String fullName;
  final String profilePictureUrl;
  final String recentMessage;
  final bool online;

  ChatCardProvider({
    Key? key,
    required this.fullName,
    required this.profilePictureUrl,
    required this.recentMessage,
    required this.online,
  }) : super(key: key);

  @override
  ChatCardView build(BuildContext context, ChatCardModel model) => ChatCardView(
        fullName: fullName,
        profilePictureUrl: profilePictureUrl,
        recentMessage: recentMessage,
        online: online,
      );

  @override
  Widget buildLoading(BuildContext context,
          {Key? testingKey, String? loadingText}) =>
      Container();

  @override
  ChatCardModel createModel() => ChatCardModel();
}
