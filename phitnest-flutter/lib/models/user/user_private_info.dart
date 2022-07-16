import 'package:cloud_firestore/cloud_firestore.dart';

import '../models.dart';

class UserPrivateInfo {
  String email;
  String mobile;
  DateTime birthday;
  bool notificationsEnabled;
  String recentIp;
  String signupIp;
  String recentPlatform;

  DateTime signupTimestamp;

  Location? recentLocation;
  Location? signupLocation;

  UserPrivateInfo(
      {required this.email,
      required this.mobile,
      required this.birthday,
      required this.notificationsEnabled,
      required this.recentIp,
      required this.signupIp,
      required this.recentPlatform,
      required this.signupTimestamp,
      this.recentLocation,
      this.signupLocation});

  factory UserPrivateInfo.fromJson(Map<String, dynamic> parsedJson) =>
      UserPrivateInfo(
        email: parsedJson['email'],
        mobile: parsedJson['mobile'],
        birthday: parsedJson['birthday'] is Timestamp
            ? (parsedJson['birthday'] as Timestamp).toDate()
            : parsedJson['birthday'],
        notificationsEnabled: parsedJson['notificationsEnabled'],
        recentIp: parsedJson['recentIp'],
        signupIp: parsedJson['signupIp'],
        signupTimestamp: parsedJson['signupTimestamp'] is Timestamp
            ? (parsedJson['signupTimestamp'] as Timestamp).toDate()
            : parsedJson['signupTimestamp'],
        recentPlatform: parsedJson['recentPlatform'],
        recentLocation: parsedJson['recentLocation'] != null
            ? Location.fromJson(parsedJson['recentLocation'])
            : null,
        signupLocation: parsedJson['signupLocation'] != null
            ? Location.fromJson(parsedJson['signupLocation'])
            : null,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'email': email,
      'mobile': mobile,
      'birthday': birthday,
      'notificationsEnabled': notificationsEnabled,
      'recentIp': recentIp,
      'signupIp': signupIp,
      'recentPlatform': recentPlatform,
      'signupTimestamp': signupTimestamp,
    };

    if (recentLocation != null) {
      json['recentLocation'] = recentLocation!.toJson();
    }

    if (signupLocation != null) {
      json['signupLocation'] = signupLocation!.toJson();
    }

    return json;
  }
}
