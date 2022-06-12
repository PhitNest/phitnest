import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phitnest/services/services.dart';

import '../../../providers.dart';

import '../../../models.dart';
import '../../../views.dart';

abstract class ChatListenerProvider<T extends BaseModel, K extends BaseView>
    extends AuthenticatedProvider<T, K> {
  late final StreamSubscription<dynamic> chatStream;

  ChatListenerProvider({Key? key}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, T model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    chatStream =
        chatService.openForegroundMessageStream(receiveMessageCallback);
    return true;
  }

  receiveMessageCallback(dynamic message);

  @override
  onDispose(T model) {
    chatStream.cancel();
    return super.onDispose(model);
  }
}
