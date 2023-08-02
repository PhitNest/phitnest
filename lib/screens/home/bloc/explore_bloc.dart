part of '../home.dart';

Future<HttpResponse<List<UserWithProfilePicture>>> explore(
    Session session) async {
  final exploreResponse = await request(
    route: '/explore',
    method: HttpMethod.get,
    parser: (json) => switch (json) {
      List<Map<String, dynamic>>() =>
        json.map((e) => UserExplore.fromJson(e)).toList(),
      _ => throw FormatException(
          'Invalid JSON for List<UserExplore>',
          json,
        ),
    },
  );
  switch (exploreResponse) {
    case HttpResponseSuccess(data: final data, headers: final headers):
      return HttpResponseOk(
        data.map((e) {
          final pfpUri = getProfilePictureUri(session, e.identityId);
          return UserWithProfilePicture(
            id: e.id,
            firstName: e.firstName,
            lastName: e.lastName,
            identityId: e.identityId,
            profilePicture: Image.network(
              pfpUri.uri.toString(),
              headers: pfpUri.headers,
            ),
          );
        }).toList(),
        headers,
      );
    case HttpResponseFailure(failure: final failure, headers: final headers):
      return HttpResponseFailure(failure, headers);
  }
}

typedef ExploreBloc
    = LoaderBloc<void, HttpResponse<List<UserWithProfilePicture>>?>;
typedef ExploreConsumer
    = LoaderConsumer<void, HttpResponse<List<UserWithProfilePicture>>?>;

extension on BuildContext {
  ExploreBloc get exploreBloc => loader();
}
