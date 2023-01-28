import '../../../../domain/entities/entities.dart';

class GetUserResponse extends UserEntity {
  final String profilePictureUrl;
  final String gym;

  GetUserResponse({
    required super.id,
    required super.cognitoId,
    required super.confirmed,
    required super.email,
    required super.firstName,
    required super.gymId,
    required super.lastName,
    required this.gym,
    required this.profilePictureUrl,
  }) : super();

  factory GetUserResponse.fromJson(Map<String, dynamic> json) =>
      GetUserResponse(
        id: json['_id'],
        cognitoId: json['cognitoId'],
        gymId: json['gymId'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        confirmed: json['confirmed'],
        profilePictureUrl: json['profilePictureUrl'],
        gym: json['gym'],
      );

  @override
  List<Object?> get props => [super.props, gym, profilePictureUrl];
}
