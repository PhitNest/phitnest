part of 'api.dart';

final class UserExplore extends Equatable {
  final Image profilePicture;
  final User user;

  const UserExplore({
    required this.user,
    required this.profilePicture,
  }) : super();

  @override
  List<Object?> get props => [user, profilePicture];
}

Future<HttpResponse<List<UserExplore>>> explore(Session session) async {
  final exploreResponse = await request(
    route: '/explore',
    method: HttpMethod.get,
    parse: (list) =>
        (list as List<Map<String, dynamic>>).map(User.parse).toList(),
  );
  switch (exploreResponse) {
    case HttpResponseSuccess(data: final data, headers: final headers):
      final usersWithPictures = (await Future.wait(
        data.map(
          (user) async {
            final pfp = await getProfilePicture(user.identityId, session);
            if (pfp != null) {
              return UserExplore(
                user: user,
                profilePicture: pfp,
              );
            } else {
              return null;
            }
          },
        ).toList(),
      ))
          .where((element) => element != null)
          .cast<UserExplore>()
          .toList();
      return HttpResponseOk(usersWithPictures, headers);
    case HttpResponseFailure(failure: final failure, headers: final headers):
      return HttpResponseFailure(failure, headers);
  }
}
