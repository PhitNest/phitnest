abstract class ChatService {
  Stream<dynamic> get foregroundMessageStream;

  openForegroundMessageStream() =>
      foregroundMessageStream.listen(receiveForegroundMessageCallback);

  Future<bool> requestNotificationPermissions();

  Future<bool> refreshConnection();

  Future<bool> sendMessage();

  receiveForegroundMessageCallback(dynamic message);

  receiveBackgroundMessageCallback(dynamic message);
}
