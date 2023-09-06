import 'package:core/core.dart';
import 'package:ui/ui.dart';

import '../entities/entities.dart';
import '../repositories/repositories.dart';

Future<HttpResponse<GetUserResponse>> user(Session session) async {
  switch (await getUser(session)) {
    case HttpResponseSuccess(data: final data, headers: final headers):
      final List<FriendRequestWithProfilePicture> sentRequests = [];
      final List<FriendRequestWithProfilePicture> receivedRequests = [];
      final List<FriendWithoutMessageWithProfilePicture> friends = [];
      final removeFromExplore = {data.user.id};
      final friendships =
          await Future.wait(data.friendships.map((friendship) async {
        final pfp = await getProfilePicture(
            session, friendship.other(data.user.id).identityId);
        if (pfp != null) {
          switch (friendship) {
            case FriendRequest(
                id: final id,
                sender: final sender,
                receiver: final receiver,
                createdAt: final createdAt
              ):
              return FriendRequestWithProfilePicture.populated(
                id: id,
                sender: sender,
                receiver: receiver,
                createdAt: createdAt,
                profilePicture: pfp,
              );
            case FriendWithoutMessage(
                id: final id,
                sender: final sender,
                receiver: final receiver,
                createdAt: final createdAt,
                acceptedAt: final acceptedAt,
              ):
              return FriendWithoutMessageWithProfilePicture(
                id: id,
                sender: sender,
                receiver: receiver,
                createdAt: createdAt,
                acceptedAt: acceptedAt,
                profilePicture: pfp,
              );
          }
        }
      }));
      for (final friendship in friendships) {
        switch (friendship) {
          case null:
            break;
          case FriendRequestWithProfilePicture(sender: final sender):
            if (sender.id == data.user.id) {
              sentRequests.add(friendship);
              removeFromExplore.add(sender.id);
            } else {
              receivedRequests.add(friendship);
            }
            break;
          case FriendWithoutMessageWithProfilePicture(sender: final sender):
            friends.add(friendship);
            removeFromExplore.add(sender.id);
            break;
          default:
            throw Exception('An unknown error has occurred.');
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
      final profilePicture =
          await getProfilePicture(session, data.user.identityId);
      if (profilePicture == null) {
        return HttpResponseOk(
          FailedToLoadProfilePicture(
            data,
            sentFriendRequests: sentRequests,
            receivedFriendRequests: receivedRequests,
            friendships: friends,
            exploreUsers: exploreUsers,
          ),
          headers,
        );
      }
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
