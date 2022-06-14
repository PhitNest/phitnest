import 'package:flutter/material.dart';
import 'package:phitnest/ui/screens/providers.dart';

import '../models.dart';
import '../views.dart';

class ChatHomeProvider
    extends ChatListenerProvider<ChatHomeModel, ChatHomeView> {
  ChatHomeProvider({Key? key}) : super(key: key);

  @override
  ChatHomeView build(BuildContext context, BaseModel model) => ChatHomeView();

  @override
  receiveMessageCallback(message) {
    throw UnimplementedError();
  }
}
