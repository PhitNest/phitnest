import 'dart:io';

import '../location/location_model.dart';
import 'user_settings_model.dart';

class UserModel {
  String userID;
  String email;
  String firstName;
  String lastName;
  String? mobile;
  bool online;
  UserSettings settings;
  int lastOnlineTimestamp;
  String recentPlatform = '${Platform.operatingSystem}';
  Location? location;
  Location? signupLocation;
  String? recentIP;
  String? signupIP;
  List photos;

  String get fullName => '$firstName $lastName';

  UserModel({
    required this.userID,
    required this.email,
    required this.firstName,
    this.recentIP,
    this.signupIP,
    this.lastName = '',
    this.mobile,
    this.online = false,
    int? lastOnlineTimestamp,
    UserSettings? settings,
    this.location,
    this.signupLocation,
    this.photos = const [],
  })  : this.lastOnlineTimestamp =
            lastOnlineTimestamp ?? DateTime.now().millisecondsSinceEpoch,
        this.settings = settings ?? UserSettings();

  factory UserModel.fromJson(Map<String, dynamic> parsedJson) => UserModel(
      userID: parsedJson['userID'],
      email: parsedJson['email'],
      firstName: parsedJson['firstName'],
      lastName: parsedJson['lastName'] ?? '',
      recentIP: parsedJson['recentIP'],
      signupIP: parsedJson['signupIP'],
      mobile: parsedJson['mobile'],
      online: parsedJson['online'] ?? false,
      lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
      settings: UserSettings.fromJson(parsedJson['settings']),
      location: parsedJson.containsKey('location')
          ? Location.fromJson(parsedJson['location'])
          : null,
      signupLocation: parsedJson.containsKey('signupLocation')
          ? Location.fromJson(parsedJson['signupLocation'])
          : null,
      photos: parsedJson['photos']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'userID': this.userID,
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'online': this.online,
      'settings': this.settings.toJson(),
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'profilePictureURL': this.profilePictureURL,
      'appIdentifier': this.appIdentifier,
      'fcmToken': this.fcmToken,

      //tinder related fields
      'showMe': this.settings.showMe,
      'location': this.location.toJson(),
      'signUpLocation': this.signUpLocation.toJson(),
      'bio': this.bio,
      'school': this.school,
      'age': this.age,
      'photos': this.photos,
    };

    if (this.mobile != null) {
      json['mobile'] = this.mobile;
    }

    if (this.signupIP != null) {
      json['signupIP'] = this.signupIP;
    }

    if (this.recentIP != null) {
      json['recentIP'] = this.recentIP;
    }

    if (this.location != null) {
      json['location'] = this.location!.toJson();
    }

    if (this.signupLocation != null) {
      json['signupLocation'] = this.signupLocation!.toJson();
    }

    return json;
  }
}
