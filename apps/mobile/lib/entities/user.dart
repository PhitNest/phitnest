import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:json_types/json.dart';

final class UserExplore extends Json {
  final idJson = Json.string('id');
  final firstNameJson = Json.string('firstName');
  final lastNameJson = Json.string('lastName');
  final identityIdJson = Json.string('identityId');

  String get id => idJson.value;
  String get firstName => firstNameJson.value;
  String get lastName => lastNameJson.value;
  String get identityId => identityIdJson.value;

  String get fullName => '$firstName $lastName';

  UserExplore.parse(super.json) : super.parse();

  UserExplore.parser() : super();

  UserExplore.populated({
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

final class UserExploreWithPicture extends Equatable {
  final Image profilePicture;
  final UserExplore user;

  const UserExploreWithPicture({
    required this.user,
    required this.profilePicture,
  }) : super();

  @override
  List<Object?> get props => [user, profilePicture];
}

final class User extends UserExplore {
  final emailJson = Json.string('email');

  String get email => emailJson.value;

  User.parse(super.json) : super.parse();

  User.parser() : super.parser();

  User.populated({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.identityId,
    required String email,
  }) : super.populated() {
    emailJson.populate(email);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [...super.keys, emailJson];
}
