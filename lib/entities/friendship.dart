import 'package:json_types/json.dart';

import 'user.dart';

sealed class Friendship extends JsonPolymorphic<Friendship> {
  final idJson = Json.string('id');
  final senderJson = Json.object('sender', User.parser);
  final receiverJson = Json.object('receiver', User.parser);
  final createdAtJson = Json.string('createdAt');

  String get id => idJson.value;
  User get sender => senderJson.value;
  User get receiver => receiverJson.value;
  String get createdAt => createdAtJson.value;

  factory Friendship.polymorphicParse(Map<String, dynamic> json) =>
      JsonPolymorphic.polymorphicParse(
          json, [FriendRequest.parser, FriendshipWithoutMessage.parser]);

  Friendship.parse(super.json) : super.parse();

  Friendship.parser() : super();

  Friendship.populated({
    required String id,
    required User sender,
    required User receiver,
    required String createdAt,
  }) : super() {
    idJson.populate(id);
    senderJson.populate(sender);
    receiverJson.populate(receiver);
    createdAtJson.populate(createdAt);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys =>
      [idJson, senderJson, receiverJson, createdAtJson];
}

final class FriendRequest extends Friendship {
  FriendRequest.parse(super.json) : super.parse();

  FriendRequest.parser() : super.parser();

  FriendRequest.populated({
    required super.id,
    required super.sender,
    required super.receiver,
    required super.createdAt,
  }) : super.populated();
}

final class FriendshipWithoutMessage extends Friendship {
  final acceptedAtJson = Json.string('acceptedAt');

  String get acceptedAt => acceptedAtJson.value;

  FriendshipWithoutMessage.parse(super.json) : super.parse();

  FriendshipWithoutMessage.parser() : super.parser();

  FriendshipWithoutMessage.populated({
    required super.id,
    required super.sender,
    required super.receiver,
    required super.createdAt,
    required String acceptedAt,
  }) : super.populated() {
    acceptedAtJson.populate(acceptedAt);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [...super.keys, acceptedAtJson];
}
