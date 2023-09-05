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
  final GetUserResponseJson json;

  User get user => json.user;
  Gym get gym => json.gym;

  const GetUserResponse(this.json) : super();

  @override
  List<Object?> get props => [json];
}

final class GetUserSuccess extends GetUserResponse {
  final Image profilePicture;
  final List<UserExploreWithPicture> exploreWithPictures;

  const GetUserSuccess(
    super.json,
    this.profilePicture,
    this.exploreWithPictures,
  ) : super();

  @override
  List<Object?> get props => [
        ...super.props,
        profilePicture,
        exploreWithPictures,
      ];
}

final class FailedToLoadProfilePicture extends GetUserResponse {
  const FailedToLoadProfilePicture(super.json) : super();
}
