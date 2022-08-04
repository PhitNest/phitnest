// THIS FILE IS AUTO GENERATED FROM ../phitnest-nodejs/lib/models/message.js
// To edit this model - follow instructions in ../utils/README.md

class Message {
  String messageId;
  DateTime createdAt;
  String conversation;
  String sender;
  String message;

  Message(this.messageId, {
    required this.createdAt,
    required this.conversation,
    required this.sender,
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> parsedJson) =>
    Message(
      parsedJson['_id'],
      createdAt: parsedJson['createdAt'],
      conversation: parsedJson['conversation'],
      sender: parsedJson['sender'],
      message: parsedJson['message'],
    );

    /// Returns < 0 if this is newer
    /// Returns 0 if [other] occurred at the same time.
    /// Retuns > 0 if [other] is newer.
    int compareTimeStamps(Message other) =>
        createdAt.compareTo(other.createdAt);
  
    operator <(Message other) => compareTimeStamps(other) < 0;
  
    operator <=(Message other) => compareTimeStamps(other) <= 0;
  
    operator >(Message other) => compareTimeStamps(other) > 0;
  
    operator >=(Message other) => compareTimeStamps(other) >= 0;
}