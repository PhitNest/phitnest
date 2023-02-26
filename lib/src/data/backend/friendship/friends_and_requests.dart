part of backend;

class FriendsAndRequestsResponse with Serializable {
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
  Map<String, dynamic> toJson() {
    return {
      'friendships': friendships.map((e) => e.toJson()).toList(),
      'requests': requests.map((e) => e.toJson()).toList(),
    };
  }
}

extension FriendsAndRequests on Friendship {
  Future<Either<FriendsAndRequestsResponse, Failure>> friendsAndRequests(
    String accessToken,
  ) =>
      _requestJson(
        route: "/friendship/friendsAndRequests",
        method: HttpMethod.get,
        parser: FriendsAndRequestsResponse.fromJson,
        authorization: accessToken,
        data: {},
      );
}
