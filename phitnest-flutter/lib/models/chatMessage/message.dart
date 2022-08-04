class Message {
  String messageId;
  String conversationId;
  String sender;
  String message;
  DateTime createdAt;

  Message(this.messageId,
      {required this.conversationId,
      required this.sender,
      required this.message,
      required this.createdAt});

  factory Message.fromJson(Map<String, dynamic> parsedJson) =>
      Message(parsedJson['_id'],
          conversationId: parsedJson['conversation'],
          sender: parsedJson['sender'],
          message: parsedJson['message'],
          createdAt: DateTime.parse(parsedJson['createdAt']));

  /// Returns < 0 if this is newer
  /// Returns 0 if [other] occurred at the same time.
  /// Retuns > 0 if [other] is newer.
  int compareTimeStamps(Message other) => createdAt.compareTo(other.createdAt);

  operator <(Message other) => compareTimeStamps(other) < 0;

  operator <=(Message other) => compareTimeStamps(other) <= 0;

  operator >(Message other) => compareTimeStamps(other) > 0;

  operator >=(Message other) => compareTimeStamps(other) >= 0;
}
