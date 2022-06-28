import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String authorId;
  String messageId;
  String text;

  List<String> photoUrls;

  /// This can either be DateTime type or Timestamp (from firestore package) type
  dynamic timeStamp;

  ChatMessage(
      {required this.authorId,
      required this.messageId,
      required this.text,
      required this.photoUrls,
      required this.timeStamp});

  factory ChatMessage.fromJson(Map<String, dynamic> parsedJson) => ChatMessage(
      authorId: parsedJson['authorId'],
      messageId: parsedJson['messageId'],
      text: parsedJson['text'],
      photoUrls: (parsedJson['photoUrls'] as List<dynamic>).cast<String>(),
      timeStamp: parsedJson['timeStamp']);

  Map<String, dynamic> toJson() => {
        'authorId': authorId,
        'messageId': messageId,
        'text': text,
        'photoUrls': photoUrls,
        'timeStamp': timeStamp,
      };

  operator <(ChatMessage other) {
    if (timeStamp is DateTime) {
      DateTime mine = timeStamp;
      DateTime yours = other.timeStamp;
      return mine.millisecondsSinceEpoch < yours.millisecondsSinceEpoch;
    } else {
      Timestamp mine = timeStamp;
      Timestamp yours = other.timeStamp;
      return mine.millisecondsSinceEpoch < yours.millisecondsSinceEpoch;
    }
  }

  operator >(ChatMessage other) => !(this < other);
}
