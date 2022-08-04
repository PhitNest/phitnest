class User {
  String userId;
  String firstName;
  String lastName;
  String mobile;
  String email;
  bool online;
  DateTime birthday;
  String bio;

  String get fullName => '$firstName${lastName == '' ? '' : ' '}$lastName';

  User(
    this.userId, {
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.online,
    required this.birthday,
    required this.bio,
  });

  factory User.fromJson(Map<String, dynamic> parsedJson) => User(
        parsedJson['_id'],
        firstName: parsedJson['firstName'],
        email: parsedJson['email'],
        mobile: parsedJson['mobile'],
        lastName: parsedJson['lastName'],
        online: parsedJson['online'],
        bio: parsedJson['bio'],
        birthday: DateTime.parse(parsedJson['birthday']),
      );
}
