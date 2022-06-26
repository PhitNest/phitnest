import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';

import '../../../../models/models.dart';
import '../../../base_provider.dart';
import 'chat_card_model.dart';
import 'chat_card_view.dart';

class ChatCardProvider extends BaseProvider<ChatCardModel, ChatCardView> {
  final UserPublicInfo userInfo;

  ChatCardProvider({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  ChatCardView build(BuildContext context, ChatCardModel model) => ChatCardView(
        fullName: userInfo.fullName,
        profilePictureUrl: userInfo.profilePictureUrl,
        recentMessage: 'Recent message :D',
        online: userInfo.online,
        onTap: () => Navigator.pushNamed(context, '/chat', arguments: userInfo),
        onDismiss: (direction) {},
        confirmDismiss: (_) => showConfirmWidget(context, 'Confirm Delete?',
            'You will not be able to restore this conversation.'),
      );

  @override
  ChatCardModel createModel() => ChatCardModel();
}
