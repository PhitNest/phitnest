import 'dart:async';
import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart';

import '../constants/constants.dart';
import '../models/models.dart';
import 'auth_api.dart';

class StreamApi {
  static StreamApi instance = StreamApi();

  bool connected = false;
  Socket? socket;

  Stream<Message>? broadcastIncomingMessages;

  refreshWebSocket() {
    socket?.dispose();
    socket = io(
        kBackEndUrl,
        OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders(AuthApi.instance.requestHeaders!)
            .enableAutoConnect()
            .build());
    socket!.onConnect((data) => connected = true);
    socket!.onDisconnect((data) => connected = false);
    StreamController<Message> incomingMessageController =
        StreamController<Message>();
    socket!.on('receiveMessage',
        (data) => incomingMessageController.sink.add(Message.fromJson(data)));
    broadcastIncomingMessages =
        incomingMessageController.stream.asBroadcastStream();
  }

  Stream<Message> streamMessages(String conversationId) {
    if (broadcastIncomingMessages == null) {
      throw WebSocketException('Web socket is not yet open');
    }
    return broadcastIncomingMessages!;
  }

  /// Send a chat message to a conversation
  void sendMessage(String conversationId, String message) {
    if (socket?.connected ?? false) {
      socket!.emit('sendMessage', {
        "conversation": conversationId,
        "message": message,
      });
    } else {
      throw WebSocketException('Web socket is not yet open');
    }
  }
}
