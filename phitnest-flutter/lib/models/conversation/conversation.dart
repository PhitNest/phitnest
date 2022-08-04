class Conversation {
  String conversationId;
  String name;
  List<String> participants;

  Conversation(this.conversationId,
      {required this.name, required this.participants});

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        json['_id'],
        name: json['name'],
        participants: (json['participants'] as List<dynamic>).cast<String>(),
      );

  bool get isGroup => participants.length > 2;
}
