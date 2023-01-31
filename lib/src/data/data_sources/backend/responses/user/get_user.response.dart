import '../../../../../common/utils/utils.dart';
import '../../../../../domain/entities/entities.dart';

class GetUserResponseParser extends Parser<GetUserResponse> {
  const GetUserResponseParser() : super();

  @override
  GetUserResponse fromJson(Map<String, dynamic> json) => GetUserResponse(
        id: json['_id'],
        cognitoId: json['cognitoId'],
        confirmed: json['confirmed'],
        firstName: json['firstName'],
        gymId: json['gymId'],
        lastName: json['lastName'],
        profilePictureUrl: json['profilePictureUrl'],
        gym: GymParser().fromJson(json['gym']),
      );
}

class GetUserResponse extends ProfilePicturePublicUserEntity {
  final GymEntity gym;

  GetUserResponse({
    required super.id,
    required super.cognitoId,
    required super.confirmed,
    required super.firstName,
    required super.gymId,
    required super.lastName,
    required super.profilePictureUrl,
    required this.gym,
  }) : super();

  @override
  List<Object?> get props => [super.props, gym];
}
