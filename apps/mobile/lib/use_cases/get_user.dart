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
      final List<FriendRequest> sentRequests = [];
      final List<FriendRequest> receivedRequests = [];
      final List<FriendshipWithoutMessage> friends = [];
      final removeFromExplore = {data.user.id};
      for (final friendship in data.friendships) {
        switch (friendship) {
          case FriendRequest(sender: final sender):
            if (sender.id == data.user.id) {
              sentRequests.add(friendship);
              removeFromExplore.add(friendship.receiver.id);
            } else {
              receivedRequests.add(friendship);
            }
          case FriendshipWithoutMessage():
            friends.add(friendship);
            removeFromExplore.add(friendship.other(data.user.id).id);
        }
      }
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
          profilePicture: profilePicture,
          exploreUsers: exploreUsers,
          sentFriendRequests: sentRequests,
          receivedFriendRequests: receivedRequests,
          friendships: friends,
        ),
        headers,
      );
    case HttpResponseFailure(failure: final failure, headers: final headers):
      return HttpResponseFailure(failure, headers);
  }
}
