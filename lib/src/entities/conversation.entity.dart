import 'package:equatable/equatable.dart';

import 'entities.dart';

class ConversationEntity extends Equatable {
  final String id;
  final List<PublicUserEntity> users;

  const ConversationEntity({
    required this.id,
    required this.users,
  }) : super();

  Map<String, dynamic> toJson() => {
        "_id": id,
        "users": users,
      };

  factory ConversationEntity.fromJson(Map<String, dynamic> json) =>
      ConversationEntity(
        id: json["_id"],
        users: List.from(json["users"])
            .map((user) => PublicUserEntity.fromJson(user))
            .toList(),
      );

  bool get isGroup => users.length > 2;

  String chatName(String userId) => isGroup
      ? "Group Chat"
      : users.firstWhere((user) => user.id != userId).fullName;

  @override
  List<Object?> get props => [id, users];
}
