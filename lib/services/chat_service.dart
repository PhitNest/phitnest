import 'dart:async';

abstract class ChatService {
  StreamSubscription<dynamic>? foregroundMessageStreamSubscription;
  Stream<dynamic> get foregroundMessageStream;

  Future<void> closeForegroundMessageStream() async =>
      foregroundMessageStreamSubscription?.cancel();

  void openForegroundMessageStream() => foregroundMessageStreamSubscription =
      foregroundMessageStream.listen(receiveForegroundMessageCallback);

  Future<bool> requestNotificationPermissions();

  Future<bool> refreshConnection();

  Future<bool> sendMessage();

  receiveForegroundMessageCallback(dynamic message);

  receiveBackgroundMessageCallback(dynamic message);
}
