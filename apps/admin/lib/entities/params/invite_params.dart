import 'package:json_types/json.dart';

final class InviteParams extends Json {
  final receiverEmailJson = Json.string('receiverEmail');
  final gymIdJson = Json.string('gymId');

  String get receiverEmail => receiverEmailJson.value;
  String get gymId => gymIdJson.value;

  InviteParams.parse(super.json) : super.parse();

  InviteParams.parser() : super();

  InviteParams.populated({
    required String receiverEmail,
    required String gymId,
  }) : super() {
    receiverEmailJson.populate(receiverEmail);
    gymIdJson.populate(gymId);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [receiverEmailJson, gymIdJson];
}
