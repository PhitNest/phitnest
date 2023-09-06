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
  final List<UserExploreWithPicture> exploreUsers;
  final List<FriendRequestWithProfilePicture> sentFriendRequests;
  final List<FriendRequestWithProfilePicture> receivedFriendRequests;
  final List<FriendWithoutMessageWithProfilePicture> friendships;

  User get user => _json.user;
  Gym get gym => _json.gym;

  const GetUserResponse(
    this._json, {
    required this.sentFriendRequests,
    required this.receivedFriendRequests,
    required this.friendships,
    required this.exploreUsers,
  }) : super();

  @override
  List<Object?> get props => [
        _json,
        sentFriendRequests,
        receivedFriendRequests,
        friendships,
        exploreUsers,
      ];
}

final class GetUserSuccess extends GetUserResponse {
  final Image profilePicture;

  const GetUserSuccess(
    super._json, {
    required this.profilePicture,
    required super.sentFriendRequests,
    required super.receivedFriendRequests,
    required super.friendships,
    required super.exploreUsers,
  }) : super();

  GetUserSuccess copyWith({
    List<FriendRequestWithProfilePicture>? sentFriendRequests,
    List<FriendRequestWithProfilePicture>? receivedFriendRequests,
    List<FriendWithoutMessageWithProfilePicture>? friendships,
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
  const FailedToLoadProfilePicture(
    super._json, {
    required super.sentFriendRequests,
    required super.receivedFriendRequests,
    required super.friendships,
    required super.exploreUsers,
  }) : super();

  GetUserSuccess copyWith(Image profilePicture) => GetUserSuccess(
        super._json,
        profilePicture: profilePicture,
        sentFriendRequests: sentFriendRequests,
        receivedFriendRequests: receivedFriendRequests,
        friendships: friendships,
        exploreUsers: exploreUsers,
      );
}
