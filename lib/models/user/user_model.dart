import 'dart:io';

import 'user_location_model.dart';
import 'user_settings_model.dart';

class UserModel {
  String userID;
  String email;
  String firstName;
  String lastName;
  String mobile;
  bool online;
  UserSettings settings;
  int lastOnlineTimestamp;
  String recentPlatform = '${Platform.operatingSystem}';
  UserLocation? location;
  UserLocation? signUpLocation;
  List photos;

  String get fullName => '$firstName $lastName';

  UserModel({
    this.userID = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.mobile = '',
    this.online = false,
    int? lastOnlineTimestamp,
    UserSettings? settings,
    this.location,
    this.signUpLocation,
    this.photos = const [],
  })  : this.lastOnlineTimestamp =
            lastOnlineTimestamp ?? DateTime.now().millisecondsSinceEpoch,
        this.settings = settings ?? UserSettings();

  factory UserModel.fromJson(Map<String, dynamic> parsedJson) => UserModel(
      userID: parsedJson['userID'],
      email: parsedJson['email'],
      firstName: parsedJson['firstName'],
      lastName: parsedJson['lastName'],
      mobile: parsedJson['mobile'],
      online: parsedJson['online'],
      lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
      settings: UserSettings.fromJson(parsedJson['settings']),
      location: parsedJson.containsKey('location')
          ? UserLocation.fromJson(parsedJson['location'])
          : null,
      signUpLocation: parsedJson.containsKey('signUpLocation')
          ? UserLocation.fromJson(parsedJson['signUpLocation'])
          : null,
      photos: parsedJson['photos']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'userID': this.userID,
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'mobile': this.mobile,
      'online': this.online,
      'settings': this.settings.toJson(),
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'recentPlatform': this.recentPlatform,
      'photos': this.photos,
    };

    if (this.location != null) {
      json['location'] = this.location!.toJson();
    }

    if (this.signUpLocation != null) {
      json['signUpLocation'] = this.signUpLocation!.toJson();
    }

    return json;
  }
}
