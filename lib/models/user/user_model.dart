import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;

  String firstName;

  String lastName;

  UserSettings settings;

  String phoneNumber;

  bool active;

  Timestamp lastOnlineTimestamp;

class UserModel {
  String userID;

  String profilePictureURL;

  String appIdentifier = 'PhitNest ${Platform.operatingSystem}';

  String fcmToken;

  bool isVip;

  //tinder related fields
  UserLocation location;

  UserLocation signUpLocation;

  bool showMe;

  String bio;

  String school;

  String age;

  List<dynamic> photos;

  //internal use only, don't save to db
  String milesAway = '0 Miles Away';

  bool selected = false;

  UserModel({
    this.email = '',
    this.userID = '',
    this.profilePictureURL = '',
    this.firstName = '',
    this.phoneNumber = '',
    this.lastName = '',
    this.active = false,
    lastOnlineTimestamp,
    settings,
    this.fcmToken = '',
    this.isVip = false,

    //tinder related fields
    this.showMe = true,
    UserLocation? location,
    UserLocation? signUpLocation,
    this.school = '',
    this.age = '',
    this.bio = '',
    this.photos = const [],
  })  : this.lastOnlineTimestamp = lastOnlineTimestamp ?? Timestamp.now(),
        this.settings = settings ?? UserSettings(),
        this.location = location ?? UserLocation(),
        this.signUpLocation = signUpLocation ?? UserLocation();

  String fullName() {
    return '$firstName $lastName';
  }

  factory UserModel.fromJson(Map<String, dynamic> parsedJson) {
    return UserModel(
        email: parsedJson['email'] ?? '',
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        active: parsedJson['active'] ?? false,
        lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
        settings: UserSettings.fromJson(parsedJson['settings']),
        location: parsedJson.containsKey('location')
            ? UserLocation.fromJson(parsedJson['location'])
            : null,
        signUpLocation: parsedJson.containsKey('signUpLocation')
            ? UserLocation.fromJson(parsedJson['signUpLocation'])
            : UserLocation(),
        school: parsedJson['school'] ?? 'N/A',
        age: parsedJson['age'] ?? '',
        bio: parsedJson['bio'] ?? 'N/A',
        photos: parsedJson['photos'] ?? [].cast<String>());
  }

  factory UserModel.fromPayload(Map<String, dynamic> parsedJson) {
    return UserModel(
        email: parsedJson['email'] ?? '',
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        active: parsedJson['active'] ?? false,
        lastOnlineTimestamp: Timestamp.fromMillisecondsSinceEpoch(
            parsedJson['lastOnlineTimestamp']),
        settings: parsedJson.containsKey('settings')
            ? UserSettings.fromJson(parsedJson['settings'])
            : UserSettings(),
        phoneNumber: parsedJson['phoneNumber'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        profilePictureURL: parsedJson['profilePictureURL'] ?? '',
        fcmToken: parsedJson['fcmToken'] ?? '',
        location: parsedJson.containsKey('location')
            ? UserLocation.fromJson(parsedJson['location'])
            : UserLocation(),
        signUpLocation: parsedJson.containsKey('signUpLocation')
            ? UserLocation.fromJson(parsedJson['signUpLocation'])
            : UserLocation(),
        school: parsedJson['school'] ?? 'N/A',
        age: parsedJson['age'] ?? '',
        bio: parsedJson['bio'] ?? 'N/A',
        isVip: parsedJson['isVip'] ?? false,
        showMe: parsedJson['showMe'] ?? parsedJson['showMeOnTinder'] ?? true,
        photos: parsedJson['photos'] ?? [].cast<String>());
  }

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
