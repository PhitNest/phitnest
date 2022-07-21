class UserPublicInfo {
  String userId;
  String firstName;
  String lastName;
  bool online;
  String bio;

  String get fullName => '$firstName${lastName == '' ? '' : ' '}$lastName';

  UserPublicInfo(
    this.userId, {
    required this.firstName,
    required this.lastName,
    required this.online,
    required this.bio,
  });

  factory UserPublicInfo.fromJson(Map<String, dynamic> parsedJson) =>
      UserPublicInfo(
        parsedJson['_id'],
        firstName: parsedJson['firstName'],
        lastName: parsedJson['lastName'],
        online: parsedJson['online'],
        bio: parsedJson['bio'],
      );
}
