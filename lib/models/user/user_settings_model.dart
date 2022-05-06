class UserSettings {
  bool pushNewMessages;
  bool pushNewMatchesEnabled;
  String gender;
  String genderPreference;
  String profilePictureURL;
  String distanceRadius;
  bool public;
  String bio;
  String age;

  UserSettings({
    this.pushNewMessages = true,
    this.pushNewMatchesEnabled = true,
    this.gender = 'Male',
    this.genderPreference = 'Female',
    this.profilePictureURL = '',
    this.distanceRadius = '10',
    this.public = true,
    this.bio = '',
    this.age = '',
  });

  factory UserSettings.fromJson(Map<dynamic, dynamic> parsedJson) =>
      UserSettings(
          pushNewMessages: parsedJson['pushNewMessages'],
          pushNewMatchesEnabled: parsedJson['pushNewMatchesEnabled'],
          gender: parsedJson['gender'],
          genderPreference: parsedJson['genderPreference'],
          profilePictureURL: parsedJson['profilePictureURL'],
          distanceRadius: parsedJson['distanceRadius'],
          public: parsedJson['public'],
          bio: parsedJson['bio'],
          age: parsedJson['age']);

  Map<String, dynamic> toJson() => {
        'pushNewMessages': this.pushNewMessages,
        'pushNewMatchesEnabled': this.pushNewMatchesEnabled,
        'gender': this.gender,
        'genderPreference': this.genderPreference,
        'profilePictureURL': this.profilePictureURL,
        'distanceRadius': this.distanceRadius,
        'public': this.public,
        'bio': this.bio,
        'age': this.age,
      };
}
