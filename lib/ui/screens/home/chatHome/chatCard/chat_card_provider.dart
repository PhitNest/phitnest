import 'package:flutter/material.dart';

import '../../../../../apis/api.dart';
import '../../../../../constants/constants.dart';
import '../../../../../models/models.dart';
import '../../../screens.dart';
import 'chat_card_model.dart';
import 'chat_card_view.dart';

class ChatCardProvider
    extends AuthenticatedProvider<ChatCardModel, ChatCardView> {
  final Conversation conversation;

  const ChatCardProvider({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  @override
  Future<bool> init(BuildContext context, ChatCardModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    model.messageStream = api<SocialApi>()
        .streamMessages(conversation.conversationId, quantity: 1)
        .map((messages) => messages.first)
        .listen((message) => model.message = message);
    if (!conversation.isGroup) {
      String userId = conversation.participants.firstWhere(
          (participantId) => participantId != model.currentUser.userId);
      model.userStream = api<SocialApi>()
          .streamUserInfo(userId)
          .listen((user) => model.otherUser = user);
    }

    return true;
  }

  @override
  Widget buildLoading(BuildContext context, {Key? testingKey}) => Container();

  @override
  ChatCardView build(BuildContext context, ChatCardModel model) => ChatCardView(
        message: model.message?.text ?? '',
        read: model.message == null ||
            model.message!.read ||
            model.message!.authorId == model.currentUser.userId,
        pictureUrl: model.otherUser?.profilePictureUrl ?? kDefaultAvatarUrl,
        onTap: () =>
            Navigator.pushNamed(context, '/chat', arguments: conversation),
        onDismissConfirm: (_) {},
        online: conversation.isGroup ? null : model.otherUser?.online,
        name: model.otherUser?.fullName ?? '',
      );

  @override
  ChatCardModel createModel() => ChatCardModel();
}
