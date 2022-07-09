class Conversation {
  String conversationId;
  List<String> participants;

  /// This can either be DateTime type or Timestamp (from firestore package) type
  /// This is the time of the most recent message
  dynamic timestamp;

  Conversation(
      {required this.conversationId,
      required this.participants,
      required this.timestamp});

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
      conversationId: json['conversationId'],
      participants: (json['participants'] as List<dynamic>).cast<String>(),
      timestamp: json['timestamp']);

  Map<String, dynamic> toJson() => {
        'conversationId': conversationId,
        'participants': participants,
        'timestamp': timestamp
      };

  bool get isGroup => participants.length > 2;

  /// Returns < 0 if [other] is older than this.
  /// Returns 0 if [other] occurred at the same time.
  /// Retuns > 0 if [other] occurred more recently than this.
  int compareTimeStamps(Conversation other) {
    return other.timestamp.millisecondsSinceEpoch -
        timestamp.millisecondsSinceEpoch;
  }

  operator <(Conversation other) => compareTimeStamps(other) < 0;

  operator <=(Conversation other) => compareTimeStamps(other) <= 0;

  operator >(Conversation other) => compareTimeStamps(other) > 0;

  operator >=(Conversation other) => compareTimeStamps(other) >= 0;
}
