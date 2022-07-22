class Conversation {
  String conversationId;
  List<String> participants;

  Conversation(this.conversationId, {required this.participants});

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        json['_id'],
        participants: (json['participants'] as List<dynamic>).cast<String>(),
      );

  bool get isGroup => participants.length > 2;
}
