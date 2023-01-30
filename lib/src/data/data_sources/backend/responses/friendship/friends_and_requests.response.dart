import 'package:equatable/equatable.dart';

import '../../../../../common/utils/utils.dart';
import '../../../../../domain/entities/entities.dart';

class FriendsAndRequestsResponseParser
    extends Parser<FriendsAndRequestsResponse> {
  const FriendsAndRequestsResponseParser() : super();

  @override
  FriendsAndRequestsResponse fromJson(Map<String, dynamic> json) =>
      FriendsAndRequestsResponse(
        friendships: PopulatedFriendshipParser().fromList(json['friendships']),
        requests: PopulatedFriendRequestParser().fromList(json['requests']),
      );
}

class FriendsAndRequestsResponse extends Equatable {
  final List<PopulatedFriendshipEntity> friendships;
  final List<PopulatedFriendRequestEntity> requests;

  FriendsAndRequestsResponse({
    required this.friendships,
    required this.requests,
  }) : super();

  @override
  List<Object?> get props => [friendships, requests];
}
