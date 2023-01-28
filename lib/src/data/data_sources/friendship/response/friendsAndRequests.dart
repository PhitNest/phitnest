import 'package:equatable/equatable.dart';

import '../../../../domain/entities/friendRequest.entity.dart';
import 'friendsAndMessage.dart';

class FriendsAndRequestsResponse extends Equatable {
  final List<PopulatedFriendshipEntity> friendships;
  final List<PopulatedFriendRequestEntity> requests;

  FriendsAndRequestsResponse({
    required this.friendships,
    required this.requests,
  }) : super();

  factory FriendsAndRequestsResponse.fromJson(Map<String, dynamic> json) =>
      FriendsAndRequestsResponse(
        friendships: List<PopulatedFriendshipEntity>.from(
          json['friendships'].map(
            (friendship) => PopulatedFriendshipEntity.fromJson(friendship),
          ),
        ),
        requests: List<PopulatedFriendRequestEntity>.from(
          json['requests'].map(
            (request) => PopulatedFriendRequestEntity.fromJson(request),
          ),
        ),
      );

  @override
  List<Object?> get props => [friendships, requests];
}
