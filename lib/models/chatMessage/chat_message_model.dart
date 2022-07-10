class ChatMessage {
  String messageId;
  String authorId;
  String text;
  bool read;

  /// This can either be DateTime type or Timestamp (from firestore package) type
  dynamic timestamp;

  ChatMessage(
      {required this.messageId,
      required this.authorId,
      required this.text,
      required this.timestamp,
      required this.read});

  factory ChatMessage.fromJson(Map<String, dynamic> parsedJson) => ChatMessage(
      messageId: parsedJson['messageId'],
      authorId: parsedJson['authorId'],
      text: parsedJson['text'],
      timestamp: parsedJson['timestamp'],
      read: parsedJson['read']);

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'authorId': authorId,
        'text': text,
        'timestamp': timestamp,
        'read': read,
      };

  /// Returns < 0 if [other] is older than this.
  /// Returns 0 if [other] occurred at the same time.
  /// Retuns > 0 if [other] occurred more recently than this.
  int compareTimeStamps(ChatMessage other) {
    return other.timestamp.millisecondsSinceEpoch -
        timestamp.millisecondsSinceEpoch;
  }

  operator <(ChatMessage other) => compareTimeStamps(other) < 0;

  operator <=(ChatMessage other) => compareTimeStamps(other) <= 0;

  operator >(ChatMessage other) => compareTimeStamps(other) > 0;

  operator >=(ChatMessage other) => compareTimeStamps(other) >= 0;
}
