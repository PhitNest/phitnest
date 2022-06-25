class UserSettings {
  bool notificationsEnabled;
  bool isPublic;
  String profilePictureUrl;
  String bio;
  String birthday;
  String? gender;

  UserSettings({
    required this.notificationsEnabled,
    required this.isPublic,
    required this.bio,
    required this.profilePictureUrl,
    required this.birthday,
    this.gender,
  });

  factory UserSettings.fromJson(Map<dynamic, dynamic> parsedJson) =>
      UserSettings(
          notificationsEnabled: parsedJson['notificationsEnabled'],
          isPublic: parsedJson['isPublic'],
          bio: parsedJson['bio'],
          profilePictureUrl: parsedJson['profilePictureUrl'],
          birthday: parsedJson['birthday'],
          // nullables
          gender: parsedJson['gender']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'notificationsEnabled': notificationsEnabled,
      'profilePictureUrl': profilePictureUrl,
      'isPublic': isPublic,
      'birthday': birthday,
      'bio': bio,
    };

    if (gender != null) {
      json['gender'] = gender;
    }

    return json;
  }
}
