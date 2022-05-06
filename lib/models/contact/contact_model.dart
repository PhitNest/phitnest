import 'package:phitnest/models/user/user_model.dart';

class ContactModel {
  ContactType type;

  UserModel user;

  ContactModel({this.type = ContactType.UNKNOWN, user})
      : this.user = user ?? UserModel();
}

enum ContactType { FRIEND, PENDING, BLOCKED, UNKNOWN, ACCEPT }
