class ChatMessage {
  String messageId;
  String sender;
  String message;
  Map<String, bool> readBy;
  DateTime sentAt;

  ChatMessage(this.messageId,
      {required this.sender,
      required this.message,
      required this.readBy,
      required this.sentAt});

  factory ChatMessage.fromJson(Map<String, dynamic> parsedJson) => ChatMessage(
      parsedJson['_id'],
      sender: parsedJson['sender'],
      message: parsedJson['message'],
      readBy:
          (parsedJson['readBy'] as Map<String, dynamic>).cast<String, bool>(),
      sentAt: DateTime.parse(parsedJson['createdAt']));

  /// Returns < 0 if this is newer
  /// Returns 0 if [other] occurred at the same time.
  /// Retuns > 0 if [other] is newer.
  int compareTimeStamps(ChatMessage other) => sentAt.compareTo(other.sentAt);

  operator <(ChatMessage other) => compareTimeStamps(other) < 0;

  operator <=(ChatMessage other) => compareTimeStamps(other) <= 0;

  operator >(ChatMessage other) => compareTimeStamps(other) > 0;

  operator >=(ChatMessage other) => compareTimeStamps(other) >= 0;
}
