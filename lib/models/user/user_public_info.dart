class UserPublicInfo {
  String userId;
  String firstName;
  String lastName;
  bool online;
  String profilePictureUrl;
  String bio;
  int lastOnlineTimestamp;
  String? gender;

  String get fullName => '$firstName${lastName == '' ? '' : ' '}$lastName';

  UserPublicInfo({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.online,
    required this.profilePictureUrl,
    required this.bio,
    required this.lastOnlineTimestamp,
    this.gender,
  });

  factory UserPublicInfo.fromJson(Map<String, dynamic> parsedJson) =>
      UserPublicInfo(
          userId: parsedJson['userId'],
          firstName: parsedJson['firstName'],
          lastName: parsedJson['lastName'],
          online: parsedJson['online'],
          profilePictureUrl: parsedJson['profilePictureUrl'],
          bio: parsedJson['bio'],
          lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
          gender: parsedJson['gender']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'online': online,
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'lastOnlineTimestamp': lastOnlineTimestamp,
    };

    if (gender != null) {
      json['gender'] = gender;
    }

    return json;
  }
}
