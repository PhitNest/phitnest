import 'package:equatable/equatable.dart';

import '../../../../../common/utils/utils.dart';
import '../../../../../domain/entities/entities.dart';

class UserExploreResponseParser extends Parser<UserExploreResponse> {
  const UserExploreResponseParser() : super();

  @override
  UserExploreResponse fromJson(Map<String, dynamic> json) =>
      UserExploreResponse(
        users: ProfilePicturePublicUserParser().fromList(json['users']),
        requests: FriendRequestParser().fromList(json['requests']),
      );
}

class UserExploreResponse extends Equatable {
  final List<ProfilePicturePublicUserEntity> users;
  final List<FriendRequestEntity> requests;

  const UserExploreResponse({
    required this.users,
    required this.requests,
  }) : super();

  @override
  List<Object?> get props => [users, requests];
}
