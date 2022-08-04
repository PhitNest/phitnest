// THIS FILE IS AUTO GENERATED FROM ../phitnest-nodejs/lib/models/conversation.js
// To edit this model - follow instructions in ../utils/README.md

class Conversation {
  String conversationId;
  DateTime createdAt;
  String name;
  List<String> participants;

  Conversation(this.conversationId, {
    required this.createdAt,
    required this.name,
    required this.participants,
  });

  factory Conversation.fromJson(Map<String, dynamic> parsedJson) =>
    Conversation(
      parsedJson['_id'],
      createdAt: parsedJson['createdAt'],
      name: parsedJson['name'],
      participants: (parsedJson['participants'] as List<dynamic>).cast<String>(),
    );

    bool get isGroup => participants.length > 2;
}