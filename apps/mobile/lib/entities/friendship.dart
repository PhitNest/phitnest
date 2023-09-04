import 'package:json_types/json.dart';

import 'user.dart';

sealed class FriendshipResponse extends JsonPolymorphic<FriendshipResponse> {
  final idJson = Json.string('id');
  final senderJson = Json.object('sender', UserExplore.parser);
  final receiverJson = Json.object('receiver', UserExplore.parser);
  final createdAtJson = Json.string('createdAt');

  String get id => idJson.value;
  UserExplore get sender => senderJson.value;
  UserExplore get receiver => receiverJson.value;
  String get createdAt => createdAtJson.value;

  factory FriendshipResponse.polymorphicParse(Map<String, dynamic> json) =>
      JsonPolymorphic.polymorphicParse(
          json, [FriendRequest.parser, FriendshipWithoutMessage.parser]);

  FriendshipResponse.parse(super.json) : super.parse();

  FriendshipResponse.parser() : super();

  FriendshipResponse.populated({
    required String id,
    required UserExplore sender,
    required UserExplore receiver,
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

final class FriendRequest extends FriendshipResponse {
  FriendRequest.parse(super.json) : super.parse();

  FriendRequest.parser() : super.parser();

  FriendRequest.populated({
    required super.id,
    required super.sender,
    required super.receiver,
    required super.createdAt,
  }) : super.populated();
}

final class FriendshipWithoutMessage extends FriendshipResponse {
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
