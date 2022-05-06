import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phitnest/services/backend_model.dart';
import 'package:provider/provider.dart';

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

  String get fullName => '$firstName $lastName';

  static UserModel? fromContext(BuildContext context) {
    return Provider.of<BackEndModel>(context).currentUser;
  }

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

  Map<String, dynamic> toPayload() {
    photos.toList().removeWhere((element) => element == null);
    return {
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'settings': this.settings.toJson(),
      'phoneNumber': this.phoneNumber,
      'id': this.userID,
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp.millisecondsSinceEpoch,
      'profilePictureURL': this.profilePictureURL,
      'appIdentifier': this.appIdentifier,
      'fcmToken': this.fcmToken,
      'location': this.location.toJson(),
      'signUpLocation': this.signUpLocation.toJson(),
      'showMe': this.settings.showMe,
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

  bool pushSuperLikesEnabled;

  bool pushTopPicksEnabled;

  String genderPreference; // should be either 'Male' or 'Female' // or 'All'

  String gender; // should be either 'Male' or 'Female'

  String distanceRadius;

  bool showMe;

  UserSettings({
    this.pushNewMessages = true,
    this.pushNewMatchesEnabled = true,
    this.pushSuperLikesEnabled = true,
    this.pushTopPicksEnabled = true,
    this.genderPreference = 'Female',
    this.gender = 'Male',
    this.distanceRadius = '10',
    this.showMe = true,
  });

  factory UserSettings.fromJson(Map<dynamic, dynamic> parsedJson) {
    return UserSettings(
      pushNewMessages: parsedJson['pushNewMessages'] ?? true,
      pushNewMatchesEnabled: parsedJson['pushNewMatchesEnabled'] ?? true,
      pushSuperLikesEnabled: parsedJson['pushSuperLikesEnabled'] ?? true,
      pushTopPicksEnabled: parsedJson['pushTopPicksEnabled'] ?? true,
      genderPreference: parsedJson['genderPreference'] ?? 'Female',
      gender: parsedJson['gender'] ?? 'Male',
      distanceRadius: parsedJson['distanceRadius'] ?? '10',
      showMe: parsedJson['showMe'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNewMessages': this.pushNewMessages,
      'pushNewMatchesEnabled': this.pushNewMatchesEnabled,
      'pushSuperLikesEnabled': this.pushSuperLikesEnabled,
      'pushTopPicksEnabled': this.pushTopPicksEnabled,
      'genderPreference': this.genderPreference,
      'gender': this.gender,
      'distanceRadius': this.distanceRadius,
      'showMe': this.showMe
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
