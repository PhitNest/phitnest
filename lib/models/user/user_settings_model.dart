class UserSettings {
  bool notificationsEnabled;
  bool public;
  String profilePictureURL;
  String bio;
  String birthday;
  String? gender;

  UserSettings({
    required this.notificationsEnabled,
    required this.public,
    required this.bio,
    required this.profilePictureURL,
    required this.birthday,
    this.gender,
  });

  factory UserSettings.fromJson(Map<dynamic, dynamic> parsedJson) =>
      UserSettings(
          notificationsEnabled: parsedJson['notificationsEnabled'],
          public: parsedJson['public'],
          bio: parsedJson['bio'],
          profilePictureURL: parsedJson['profilePictureURL'],
          birthday: parsedJson['birthday'],
          // nullables
          gender: parsedJson['gender']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'notificationsEnabled': notificationsEnabled,
      'profilePictureURL': profilePictureURL,
      'public': public,
      'birthday': birthday,
      'bio': bio,
    };

    if (gender != null) {
      json['gender'] = gender;
    }

    return json;
  }
}
