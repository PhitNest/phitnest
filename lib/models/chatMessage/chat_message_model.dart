import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String messageId;
  String authorId;
  String recipientId;
  String text;
  bool read;

  /// This can either be DateTime type or Timestamp (from firestore package) type
  dynamic timeStamp;

  ChatMessage(
      {required this.messageId,
      required this.authorId,
      required this.recipientId,
      required this.text,
      required this.timeStamp,
      required this.read});

  factory ChatMessage.fromJson(Map<String, dynamic> parsedJson) => ChatMessage(
      messageId: parsedJson['messageId'],
      authorId: parsedJson['authorId'],
      recipientId: parsedJson['recipientId'],
      text: parsedJson['text'],
      timeStamp: parsedJson['timeStamp'],
      read: parsedJson['read']);

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'authorId': authorId,
        'recipientId': recipientId,
        'text': text,
        'timeStamp': timeStamp,
        'read': read,
      };

  /// Returns < 0 if [other] is older than this.
  /// Returns 0 if [other] occurred at the same time.
  /// Retuns > 0 if [other] occurred more recently than this.
  int compareTimeStamps(ChatMessage other) {
    return other.timeStamp.millisecondsSinceEpoch -
        timeStamp.millisecondsSinceEpoch;
  }

  operator <(ChatMessage other) => compareTimeStamps(other) < 0;

  operator <=(ChatMessage other) => compareTimeStamps(other) <= 0;

  operator >(ChatMessage other) => compareTimeStamps(other) > 0;

  operator >=(ChatMessage other) => compareTimeStamps(other) >= 0;
}
