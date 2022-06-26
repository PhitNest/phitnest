import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';

import '../../../../models/models.dart';
import '../../../base_provider.dart';
import 'chat_card_model.dart';
import 'chat_card_view.dart';

class ChatCardProvider extends BaseProvider<ChatCardModel, ChatCardView> {
  final UserModel user;

  ChatCardProvider({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  ChatCardView build(BuildContext context, ChatCardModel model) => ChatCardView(
        fullName: user.fullName,
        profilePictureUrl: user.settings.profilePictureUrl,
        recentMessage: 'Recent message :D',
        online: user.online,
        onTap: () => Navigator.pushNamed(context, '/chat', arguments: user),
        onDismiss: (direction) {},
        confirmDismiss: (_) => showConfirmWidget(context, 'Confirm Delete?',
            'You will not be able to restore this conversation.'),
      );

  @override
  ChatCardModel createModel() => ChatCardModel();
}
