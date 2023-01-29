import 'package:equatable/equatable.dart';

import '../../../../domain/entities/friend_request.entity.dart';
import '../../../../domain/entities/user.entity.dart';

class UserExploreResponse extends Equatable {
  final List<FriendRequestEntity> request;
  final List<ProfilePicturePublicUserEntity> users;

  UserExploreResponse({
    required this.request,
    required this.users,
  }) : super();

  factory UserExploreResponse.fromJson(Map<String, dynamic> json) =>
      UserExploreResponse(request: [
        FriendRequestEntity.fromJson(json['request'])
      ], users: [
        ProfilePicturePublicUserEntity(
          id: json['users']['_id'],
          cognitoId: json['users']['cognitoId'],
          confirmed: json['users']['confirmed'],
          firstName: json['users']['firstName'],
          gymId: json['users']['gymId'],
          lastName: json['users']['lastName'],
          profilePictureUrl: json['users']['profilePictureUrl'],
        )
      ]);

  @override
  List<Object?> get props => [request, users];
}

class ProfilePicturePublicUserEntity extends PublicUserEntity {
  final String profilePictureUrl;

  ProfilePicturePublicUserEntity({
    required super.id,
    required super.cognitoId,
    required super.confirmed,
    required super.firstName,
    required super.gymId,
    required super.lastName,
    required this.profilePictureUrl,
  }) : super();

  @override
  List<Object?> get props => [super.props, profilePictureUrl];
}
