part of backend;

class UserExploreResponse extends Equatable {
  final List<ProfilePicturePublicUserEntity> users;
  final List<FriendRequestEntity> requests;

  const UserExploreResponse({
    required this.users,
    required this.requests,
  }) : super();

  factory UserExploreResponse.fromJson(Map<String, dynamic> json) =>
      UserExploreResponse(
        users: (json['users'] as List<dynamic>)
            .map((json) => ProfilePicturePublicUserEntity.fromJson(json))
            .toList(),
        requests: (json['requests'] as List<dynamic>)
            .map((json) => FriendRequestEntity.fromJson(json))
            .toList(),
      );

  @override
  List<Object> get props => [users, requests];
}

extension Explore on _User {
  Future<Either<UserExploreResponse, Failure>> explore({
    required String accessToken,
    required String gymId,
  }) =>
      _requestJson(
        route: "/user/explore",
        method: HttpMethod.get,
        parser: UserExploreResponse.fromJson,
        authorization: accessToken,
        data: {
          "gymId": gymId,
        },
      );
}
