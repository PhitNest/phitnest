import 'package:phitnest/models/user/user_model.dart';

class ContactModel {
  ContactType type;

  User user;

  ContactModel({this.type = ContactType.UNKNOWN, user})
      : this.user = user ?? User();
}

enum ContactType { FRIEND, PENDING, BLOCKED, UNKNOWN, ACCEPT }