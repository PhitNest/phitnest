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
    this.profilePictureURL,
    this.gender,
  });

  factory UserSettings.fromJson(Map<dynamic, dynamic> parsedJson) =>
      UserSettings(
          notificationsEnabled: parsedJson['notificationsEnabled'],
          public: parsedJson['public'],
          bio: parsedJson['bio'],
          // nullables
          birthday: parsedJson['birthday'],
          profilePictureURL: parsedJson['profilePictureURL'],
          gender: parsedJson['gender']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'notificationsEnabled': notificationsEnabled,
      'gender': gender,
      'profilePictureURL': profilePictureURL,
    };

    if (birthday != null) {
      json['birthday'] = birthday;
    }

    if (profilePictureURL != null) {
      json['profilePictureURL'] = profilePictureURL;
    }

    if (gender != null) {
      json['gender'] = gender;
    }

    return json;
  }
}
