class ConversationModel {
  String name;
  String recentMessage;
  bool selected;

  ConversationModel({
    required this.name,
    required this.recentMessage,
    this.selected = false,
  });
}
