class ChatMessage {
  String authorId;
  String messageId;
  String text;

  List<String> photoUrls;

  /// Firestore Timestamp if using firestore, or DateTime if using REST
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
}
