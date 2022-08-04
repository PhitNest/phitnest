// THIS FILE IS AUTO GENERATED FROM ../phitnest-nodejs/lib/models/user.js
// To edit this model - follow instructions in ../utils/README.md

class User {
  String userId;
  DateTime createdAt;
  String email;
  String password;
  String mobile;
  String firstName;
  String lastName;
  String bio;
  bool online;
  DateTime birthday;
  DateTime lastSeen;

  User(this.userId, {
    required this.createdAt,
    required this.email,
    required this.password,
    required this.mobile,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.online,
    required this.birthday,
    required this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> parsedJson) =>
    User(
      parsedJson['_id'],
      createdAt: parsedJson['createdAt'],
      email: parsedJson['email'],
      password: parsedJson['password'],
      mobile: parsedJson['mobile'],
      firstName: parsedJson['firstName'],
      lastName: parsedJson['lastName'],
      bio: parsedJson['bio'],
      online: parsedJson['online'],
      birthday: parsedJson['birthday'],
      lastSeen: parsedJson['lastSeen'],
    );

    String get fullName => '$firstName${lastName == '' ? '' : ' '}$lastName';

}