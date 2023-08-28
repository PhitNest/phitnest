import 'package:json_types/json.dart';

final class AdminInviteParams extends Json {
  final receiverEmailJson = Json.string('receiverEmail');
  final gymIdJson = Json.string('gymId');

  String get receiverEmail => receiverEmailJson.value;
  String get gymId => gymIdJson.value;

  AdminInviteParams.parse(super.json) : super.parse();

  AdminInviteParams.parser() : super();

  AdminInviteParams.populated({
    required String receiverEmail,
    required String gymId,
  }) : super() {
    receiverEmailJson.populate(receiverEmail);
    gymIdJson.populate(gymId);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [receiverEmailJson, gymIdJson];
}
