import 'package:core/core.dart';
import 'package:ui/ui.dart';

import '../entities/entities.dart';
import '../repositories/repositories.dart';

Future<HttpResponse<GetUserResponse>> user(Session session) async {
  switch (await getUser(session)) {
    case HttpResponseSuccess(data: final data, headers: final headers):
      final profilePicture =
          await getProfilePicture(session, data.user.identityId);
      if (profilePicture == null) {
        return HttpResponseOk(FailedToLoadProfilePicture(data), headers);
      }
      final removeFromExplore = {
        data.user.id,
        ...data.friendships.map((f) => switch (f) {
              FriendRequest(sender: final sender) => sender.id == data.user.id,
              _ => true,
            })
      };
      final exploreUsers = (await Future.wait(data.explore.map((user) async {
        final profilePicture =
            await getProfilePicture(session, user.identityId);
        if (profilePicture != null) {
          return UserExploreWithPicture(
            user: user,
            profilePicture: profilePicture,
          );
        }
        return null;
      })))
          .where((exploreUser) =>
              exploreUser != null &&
              !removeFromExplore.contains(exploreUser.user.id))
          .cast<UserExploreWithPicture>()
          .toList();
      return HttpResponseOk(
        GetUserSuccess(
          data,
          profilePicture,
          exploreUsers,
        ),
        headers,
      );
    case HttpResponseFailure(failure: final failure, headers: final headers):
      return HttpResponseFailure(failure, headers);
  }
}
