import '../../../../../common/utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../backend.dart';

class UserExploreResponseParser extends Parser<UserExploreResponse> {
  const UserExploreResponseParser() : super();

  @override
  UserExploreResponse fromJson(Map<String, dynamic> json) =>
      UserExploreResponse(
        user: ProfilePicturePublicUserParser().fromList(json['user']),
        request: FriendRequestParser().fromList(json['request']),
      );
}

class UserExploreResponse extends Request {
  final List<ProfilePicturePublicUserEntity> user;
  final List<FriendRequestEntity> request;

  const UserExploreResponse({
    required this.user,
    required this.request,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'user': List<ProfilePicturePublicUserEntity>.from(user)
            .map((u) => u.toJson())
            .toList(),
        'request': List<FriendRequestEntity>.from(request)
            .map((req) => req.toJson())
            .toList(),
      };

  @override
  List<Object?> get props => [user, request];
}
