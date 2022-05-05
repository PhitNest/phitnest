import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;

  String firstName;

  String lastName;

  UserSettings settings;

  String mobile;

  bool online;

  Timestamp lastOnlineTimestamp;

  String userID;

  String recentPlatform = '${Platform.operatingSystem}';

  UserLocation location;

  UserLocation signUpLocation;

  bool public;

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
    this.firstName = '',
    this.mobile = '',
    this.lastName = '',
    this.online = false,
    lastOnlineTimestamp,
    settings,

    //tinder related fields
    this.public = true,
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
        online: parsedJson['online'] ?? false,
        lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
        settings: parsedJson.containsKey('settings')
            ? UserSettings.fromJson(parsedJson['settings'])
            : UserSettings(),
        mobile: parsedJson['mobile'] ?? '',
        userID: parsedJson['userID'] ?? '',
        //dating app related fields
        public: parsedJson['public'] ?? true,
        location: parsedJson.containsKey('location')
            ? UserLocation.fromJson(parsedJson['location'])
            : UserLocation(),
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
        online: parsedJson['online'] ?? false,
        lastOnlineTimestamp: Timestamp.fromMillisecondsSinceEpoch(
            parsedJson['lastOnlineTimestamp']),
        settings: parsedJson.containsKey('settings')
            ? UserSettings.fromJson(parsedJson['settings'])
            : UserSettings(),
        mobile: parsedJson['mobile'] ?? '',
        userID: parsedJson['userID'] ?? '',
        location: parsedJson.containsKey('location')
            ? UserLocation.fromJson(parsedJson['location'])
            : UserLocation(),
        signUpLocation: parsedJson.containsKey('signUpLocation')
            ? UserLocation.fromJson(parsedJson['signUpLocation'])
            : UserLocation(),
        school: parsedJson['school'] ?? 'N/A',
        age: parsedJson['age'] ?? '',
        bio: parsedJson['bio'] ?? 'N/A',
        public: parsedJson['public'] ?? true,
        photos: parsedJson['photos'] ?? [].cast<String>());
  }

  Map<String, dynamic> toJson() {
    photos.toList().removeWhere((element) => element == null);
    return {
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'settings': this.settings.toJson(),
      'mobile': this.mobile,
      'userID': this.userID,
      'online': this.online,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'recentPlatform': this.recentPlatform,
      'location': this.location.toJson(),
      'signUpLocation': this.signUpLocation.toJson(),
      'bio': this.bio,
      'school': this.school,
      'age': this.age,
      'photos': this.photos,
    };
  }

  Map<String, dynamic> toPayload() {
    photos.toList().removeWhere((element) => element == null);
    return {
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'settings': this.settings.toJson(),
      'mobile': this.mobile,
      'userID': this.userID,
      'online': this.online,
      'lastOnlineTimestamp': this.lastOnlineTimestamp.millisecondsSinceEpoch,
      'recentPlatform': this.recentPlatform,
      'location': this.location.toJson(),
      'signUpLocation': this.signUpLocation.toJson(),
      'bio': this.bio,
      'school': this.school,
      'age': this.age,
      'photos': this.photos,
    };
  }
}

class UserSettings {
  bool pushNewMessages;

  bool pushNewMatchesEnabled;

  String profilePictureURL;

  String genderPreference; // should be either 'Male' or 'Female' // or 'All'

  String gender; // should be either 'Male' or 'Female'

  String distanceRadius;

  UserSettings({
    this.pushNewMessages = true,
    this.pushNewMatchesEnabled = true,
    this.profilePictureURL = '',
    this.genderPreference = 'Female',
    this.gender = 'Male',
    this.distanceRadius = '10',
  });

  factory UserSettings.fromJson(Map<dynamic, dynamic> parsedJson) {
    return UserSettings(
      pushNewMessages: parsedJson['pushNewMessages'] ?? true,
      pushNewMatchesEnabled: parsedJson['pushNewMatchesEnabled'] ?? true,
      profilePictureURL: parsedJson['profilePictureURL'] ?? '',
      genderPreference: parsedJson['genderPreference'] ?? 'Female',
      gender: parsedJson['gender'] ?? 'Male',
      distanceRadius: parsedJson['distanceRadius'] ?? '10',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNewMessages': this.pushNewMessages,
      'pushNewMatchesEnabled': this.pushNewMatchesEnabled,
      'profilePictureURL': this.profilePictureURL,
      'genderPreference': this.genderPreference,
      'gender': this.gender,
      'distanceRadius': this.distanceRadius,
    };
  }
}

class UserLocation {
  double latitude;

  double longitude;

  UserLocation({this.latitude = 00.1, this.longitude = 00.1});

  factory UserLocation.fromJson(Map<dynamic, dynamic>? parsedJson) {
    return UserLocation(
      latitude: parsedJson?['latitude'] ?? 00.1,
      longitude: parsedJson?['longitude'] ?? 00.1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': this.latitude,
      'longitude': this.longitude,
    };
  }
}
