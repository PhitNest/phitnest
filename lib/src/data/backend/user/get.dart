part of backend;

class GetUserResponse extends ProfilePictureUserEntity {
  final GymEntity gym;

  GetUserResponse({
    required super.id,
    required super.email,
    required super.cognitoId,
    required super.confirmed,
    required super.firstName,
    required super.gymId,
    required super.lastName,
    required super.profilePictureUrl,
    required this.gym,
  }) : super();

  factory GetUserResponse.fromJson(Map<String, dynamic> json) =>
      GetUserResponse(
        id: json['_id'],
        email: json['email'],
        cognitoId: json['cognitoId'],
        confirmed: json['confirmed'],
        firstName: json['firstName'],
        gymId: json['gymId'],
        lastName: json['lastName'],
        profilePictureUrl: json['profilePictureUrl'],
        gym: GymEntity.fromJson(json['gym']),
      );

  @override
  List<Object?> get props => [...super.props, gym];
}

extension GetUser on User {
  Future<Either<GetUserResponse, Failure>> get(String accessToken) =>
      _requestJson(
        route: "/user",
        method: HttpMethod.get,
        parser: GetUserResponse.fromJson,
        authorization: accessToken,
        data: {},
      );
}
