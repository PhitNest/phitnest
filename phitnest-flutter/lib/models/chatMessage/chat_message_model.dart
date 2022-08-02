class ChatMessage {
  String messageId;
  String conversationId;
  String sender;
  String message;
  DateTime createdAt;

  ChatMessage(this.messageId,
      {required this.conversationId,
      required this.sender,
      required this.message,
      required this.createdAt});

  factory ChatMessage.fromJson(Map<String, dynamic> parsedJson) =>
      ChatMessage(parsedJson['_id'],
          conversationId: parsedJson['conversationId'],
          sender: parsedJson['sender'],
          message: parsedJson['message'],
          createdAt: DateTime.parse(parsedJson['createdAt']));

  /// Returns < 0 if this is newer
  /// Returns 0 if [other] occurred at the same time.
  /// Retuns > 0 if [other] is newer.
  int compareTimeStamps(ChatMessage other) =>
      createdAt.compareTo(other.createdAt);

  operator <(ChatMessage other) => compareTimeStamps(other) < 0;

  operator <=(ChatMessage other) => compareTimeStamps(other) <= 0;

  operator >(ChatMessage other) => compareTimeStamps(other) > 0;

  operator >=(ChatMessage other) => compareTimeStamps(other) >= 0;
}
