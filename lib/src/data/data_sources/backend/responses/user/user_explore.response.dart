import '../../../../../common/utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../backend.dart';

class UserExploreResponseParser extends Parser<UserExploreResponse> {
  const UserExploreResponseParser() : super();

  @override
  UserExploreResponse fromJson(Map<String, dynamic> json) =>
      UserExploreResponse(
        user: ProfilePicturePublicUserParser().fromJson(json['user']),
        request: FriendRequestParser().fromJson(json['request']),
      );
}

class UserExploreResponse extends Request {
  final ProfilePicturePublicUserEntity user;
  final FriendRequestEntity request;

  const UserExploreResponse({
    required this.user,
    required this.request,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'request': request.toJson(),
      };

  @override
  List<Object?> get props => [user, request];
}
