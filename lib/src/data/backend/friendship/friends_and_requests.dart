part of backend;

class FriendsAndRequestsResponse extends Equatable {
  final List<PopulatedFriendshipEntity> friendships;
  final List<PopulatedFriendRequestEntity> requests;

  FriendsAndRequestsResponse({
    required this.friendships,
    required this.requests,
  }) : super();

  factory FriendsAndRequestsResponse.fromJson(Map<String, dynamic> json) =>
      FriendsAndRequestsResponse(
        friendships: (json['friendships'] as List<dynamic>)
            .map((json) => PopulatedFriendshipEntity.fromJson(json))
            .toList(),
        requests: (json['requests'] as List<dynamic>)
            .map((json) => PopulatedFriendRequestEntity.fromJson(json))
            .toList(),
      );

  @override
  List<Object> get props => [friendships, requests];
}

extension FriendsAndRequests on Friendship {
  Future<Either<FriendsAndRequestsResponse, Failure>> friendsAndRequests(
          String accessToken) =>
      _requestJson(
        route: "/friendship/friendsAndRequests",
        method: HttpMethod.get,
        parser: FriendsAndRequestsResponse.fromJson,
        authorization: accessToken,
        data: {},
      );
}
