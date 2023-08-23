part of 'api.dart';

final class AdminInviteParams extends Json {
  final emailJson = Json.string('email');
  final gymIdJson = Json.string('gymId');

  String get email => emailJson.value;
  String get gymId => gymIdJson.value;

  AdminInviteParams.parse(super.json) : super.parse();

  AdminInviteParams.parser() : super();

  AdminInviteParams.populated({
    required String email,
    required String gymId,
  }) : super() {
    emailJson.populate(email);
    gymIdJson.populate(gymId);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [emailJson, gymIdJson];
}

Future<HttpResponse<void>> adminInvite(
        AdminInviteParams params, Session session) =>
    request(
      route: '/adminInvite',
      method: HttpMethod.post,
      session: session,
      data: params.toJson(),
      parse: (_) {},
    );
