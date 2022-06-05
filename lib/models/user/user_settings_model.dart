class UserSettings {
  bool notificationsEnabled;
  bool public;
  String bio;
  String? birthday;
  String? profilePictureURL;
  String? gender;

  UserSettings({
    required this.notificationsEnabled,
    required this.public,
    required this.bio,
    this.birthday,
    this.gender,
  });

  factory UserSettings.fromJson(Map<dynamic, dynamic> parsedJson) =>
      UserSettings(
          notificationsEnabled: parsedJson['notificationsEnabled'],
          public: parsedJson['public'],
          bio: parsedJson['bio'],
          // nullables
          birthday: parsedJson['birthday'],
          gender: parsedJson['gender']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'notificationsEnabled': notificationsEnabled,
      'public': public,
      'bio': bio,
    };

    if (birthday != null) {
      json['birthday'] = birthday;
    }

    if (gender != null) {
      json['gender'] = gender;
    }

    return json;
  }
}
