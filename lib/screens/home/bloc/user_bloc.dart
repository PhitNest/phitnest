part of '../home.dart';

sealed class GetUserResponse extends Equatable {
  const GetUserResponse() : super();
}

final class GetUserSuccess extends GetUserResponse {
  final UserWithProfilePicture user;

  const GetUserSuccess({
    required this.user,
  }) : super();

  @override
  List<Object?> get props => [user];
}

final class FailedToLoadUser extends GetUserResponse {
  final Failure error;

  const FailedToLoadUser({
    required this.error,
  }) : super();

  @override
  List<Object?> get props => [error];
}

final class FailedToLoadProfilePicture extends GetUserResponse {
  const FailedToLoadProfilePicture() : super();

  @override
  List<Object?> get props => [];
}

Future<Image?> getProfilePicture(Session session) async {
  final identityId = session.credentials.userIdentityId;
  if (identityId == null) {
    prettyLogger.e('Tried to get profile picture but identity ID is null');
    return null;
  }
  try {
    final params = getProfilePictureUri(session, identityId);
    final res = await http.get(params.uri, headers: params.headers);
    if (res.statusCode == 200) {
      return Image.memory(res.bodyBytes);
    } else {
      prettyLogger.e('Error while retrieving profile picture\n'
          'Identity ID: $identityId\n'
          'Response: ${res.body}');
      return null;
    }
  } catch (e) {
    prettyLogger.e('Error thrown while retrieving profile picture\n'
        'Identity ID: $identityId\n'
        'Error: ${e.toString()}');
    return null;
  }
}

Future<void> cacheUser(UserExplore? user) => cacheObject('user', user);

Future<GetUserResponse> getUser(Session session) async {
  final userExploreResponse = await request(
    route: '/user',
    method: HttpMethod.get,
    writeToCache: cacheUser,
    readFromCache: () => getCachedObject('user', UserExplore.fromJson),
    parser: (json) => switch (json) {
      Map<String, dynamic>() => UserExplore.fromJson(json),
      _ => throw FormatException(
          'Invalid JSON for UserExplore',
          json,
        ),
    },
  );
  switch (userExploreResponse) {
    case HttpResponseSuccess(data: final user):
      final profilePicture = await getProfilePicture(
        session,
      );
      if (profilePicture == null) {
        return const FailedToLoadProfilePicture();
      } else {
        return GetUserSuccess(
          user: UserWithProfilePicture(
            firstName: user.firstName,
            lastName: user.lastName,
            id: user.id,
            identityId: user.identityId,
            profilePicture: profilePicture,
          ),
        );
      }
    case HttpResponseFailure(failure: final failure):
      return FailedToLoadUser(error: failure);
  }
}

typedef UserBloc = LoaderBloc<void, GetUserResponse?>;
typedef UserConsumer = LoaderConsumer<void, GetUserResponse?>;

extension on BuildContext {
  UserBloc get userBloc => loader();
}
