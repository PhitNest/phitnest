import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_types/json.dart';

import '../entities.dart';

final class GetUserResponseJson extends Json {
  final userJson = Json.object('user', User.parser);
  final friendshipsJson =
      Json.polymorphicList('friendships', FriendshipResponse.polymorphicParse);
  final exploreJson = Json.objectList('exploreUsers', UserExplore.parser);
  final gymJson = Json.object('gym', Gym.parser);

  User get user => userJson.value;
  List<FriendshipResponse> get friendships => friendshipsJson.value;
  List<UserExplore> get explore => exploreJson.value;
  Gym get gym => gymJson.value;

  GetUserResponseJson.parse(super.json) : super.parse();

  GetUserResponseJson.parser() : super();

  GetUserResponseJson.populated({
    required User user,
    required List<FriendshipResponse> friendships,
    required List<UserExplore> explore,
    required Gym gym,
  }) : super() {
    userJson.populate(user);
    friendshipsJson.populate(friendships);
    exploreJson.populate(explore);
    gymJson.populate(gym);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys =>
      [userJson, friendshipsJson, exploreJson, gymJson];
}

sealed class GetUserResponse extends Equatable {
  final GetUserResponseJson _json;

  User get user => _json.user;
  Gym get gym => _json.gym;

  const GetUserResponse(
    this._json,
  ) : super();

  @override
  List<Object?> get props => [_json];
}

final class GetUserSuccess extends GetUserResponse {
  final Image profilePicture;
  final List<UserExploreWithPicture> exploreUsers;
  final List<FriendRequest> sentFriendRequests;
  final List<FriendRequest> receivedFriendRequests;
  final List<FriendshipWithoutMessage> friendships;

  const GetUserSuccess(
    super._json, {
    required this.sentFriendRequests,
    required this.receivedFriendRequests,
    required this.friendships,
    required this.profilePicture,
    required this.exploreUsers,
  }) : super();

  GetUserSuccess copyWith({
    List<FriendRequest>? sentFriendRequests,
    List<FriendRequest>? receivedFriendRequests,
    List<FriendshipWithoutMessage>? friendships,
    Image? profilePicture,
    List<UserExploreWithPicture>? exploreUsers,
  }) =>
      GetUserSuccess(
        super._json,
        sentFriendRequests: sentFriendRequests ?? this.sentFriendRequests,
        receivedFriendRequests:
            receivedFriendRequests ?? this.receivedFriendRequests,
        friendships: friendships ?? this.friendships,
        profilePicture: profilePicture ?? this.profilePicture,
        exploreUsers: exploreUsers ?? this.exploreUsers,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        sentFriendRequests,
        receivedFriendRequests,
        friendships,
        profilePicture,
        exploreUsers,
      ];
}

final class FailedToLoadProfilePicture extends GetUserResponse {
  const FailedToLoadProfilePicture(super._json) : super();
}
