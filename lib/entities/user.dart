import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:json_types/json.dart';

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
