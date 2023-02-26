part of backend;

class FriendsAndMessagesResponse extends Equatable with Serializable {
  final PopulatedFriendshipEntity friendship;
  final DirectMessageEntity? message;

  FriendsAndMessagesResponse({
    required this.friendship,
    required this.message,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'friendship': friendship.toJson(),
        ...(message != null ? {'message': message!.toJson()} : {}),
      };

  factory FriendsAndMessagesResponse.fromJson(Map<String, dynamic> json) =>
      FriendsAndMessagesResponse(
        friendship: PopulatedFriendshipEntity.fromJson(json['friendship']),
        message: json['message'] != null
            ? DirectMessageEntity.fromJson(json['message'])
            : null,
      );

  @override
  List<Object?> get props => [friendship, message];
}

extension FriendsAndMessages on Friendship {
  Future<Either<List<FriendsAndMessagesResponse>, Failure>> friendsAndMessages(
          String accessToken) =>
      _requestList(
        route: "/friendship/friendsAndMessages",
        method: HttpMethod.get,
        parser: FriendsAndMessagesResponse.fromJson,
        authorization: accessToken,
        data: {},
      );
}
