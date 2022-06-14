import 'dart:async';

abstract class ChatService {
  Stream<dynamic> get foregroundMessageStream;

  StreamSubscription<dynamic> openForegroundMessageStream(
          Function(dynamic message) receiveMessage) =>
      foregroundMessageStream.listen(receiveMessage);

  Future<bool> requestNotificationPermissions();

  Future<bool> sendMessage();

  receiveBackgroundMessageCallback(dynamic message);
}
