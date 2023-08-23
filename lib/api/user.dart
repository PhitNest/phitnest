part of 'api.dart';

final class User extends Json {
  final idJson = Json.string('id');
  final firstNameJson = Json.string('firstName');
  final lastNameJson = Json.string('lastName');
  final identityIdJson = Json.string('identityId');

  String get id => idJson.value;
  String get firstName => firstNameJson.value;
  String get lastName => lastNameJson.value;
  String get identityId => identityIdJson.value;

  User.parse(super.json) : super.parse();

  User.parser() : super();

  User.populated({
    required String id,
    required String firstName,
    required String lastName,
    required String identityId,
  }) : super() {
    idJson.populate(id);
    firstNameJson.populate(firstName);
    lastNameJson.populate(lastName);
    identityIdJson.populate(identityId);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys =>
      [idJson, firstNameJson, lastNameJson, identityIdJson];
}

sealed class GetUserResponse extends Equatable {
  final User user;

  const GetUserResponse(this.user) : super();

  @override
  List<Object?> get props => [user];
}

final class GetUserSuccess extends GetUserResponse {
  final Image profilePicture;

  const GetUserSuccess(super.user, this.profilePicture) : super();

  @override
  List<Object?> get props => [user, profilePicture];
}

final class FailedToLoadProfilePicture extends GetUserResponse {
  const FailedToLoadProfilePicture(super.user) : super();
}

Future<HttpResponse<GetUserResponse>> getUser(Session session) async {
  final userResponse = await request(
    route: '/user',
    method: HttpMethod.get,
    parse: (json) => User.parse(json as Map<String, dynamic>),
    session: session,
  );
  switch (userResponse) {
    case HttpResponseSuccess(data: final data, headers: final headers):
      final profilePicture = await getProfilePicture(data.identityId, session);
      if (profilePicture == null) {
        return HttpResponseOk(FailedToLoadProfilePicture(data), headers);
      } else {
        return HttpResponseOk(
          GetUserSuccess(
            User.populated(
              id: data.id,
              firstName: data.firstName,
              lastName: data.lastName,
              identityId: data.identityId,
            ),
            profilePicture,
          ),
          headers,
        );
      }
    case HttpResponseFailure(failure: final failure, headers: final headers):
      return HttpResponseFailure(failure, headers);
  }
}
