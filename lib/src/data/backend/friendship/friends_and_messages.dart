part of backend;

class FriendsAndMessagesResponse extends Equatable {
  final PopulatedFriendshipEntity friendship;
  final DirectMessageEntity? message;

  FriendsAndMessagesResponse({
    required this.friendship,
    required this.message,
  }) : super();

  factory FriendsAndMessagesResponse.fromJson(Map<String, dynamic> json) =>
      FriendsAndMessagesResponse(
        friendship: PopulatedFriendshipEntity.fromJson(json['friendship']),
        message: json['message'] != null
            ? DirectMessageEntity.fromJson(json['message'])
            : null,
      );

  @override
  List<Object> get props => [friendship, message ?? ""];
}

Future<Either<List<FriendsAndMessagesResponse>, Failure>> _friendsAndMessages({
  required String accessToken,
}) =>
    _requestList(
      route: "/friendship/friendsAndMessages",
      method: HttpMethod.get,
      parser: FriendsAndMessagesResponse.fromJson,
      authorization: accessToken,
      data: {},
    );
