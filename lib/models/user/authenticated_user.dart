import '../models.dart';

class AuthenticatedUser {
  UserPublicInfo publicInfo;
  UserPrivateInfo privateInfo;

  // Public
  String get userId => publicInfo.userId;
  String get firstName => publicInfo.firstName;
  String get lastName => publicInfo.lastName;
  bool get online => publicInfo.online;
  String get profilePictureUrl => publicInfo.profilePictureUrl;
  String get bio => publicInfo.bio;
  dynamic get lastOnlineTimestamp => publicInfo.lastOnlineTimestamp;
  String? get gender => publicInfo.gender;

  String get fullName => publicInfo.fullName;

  set userId(String userId) => publicInfo.userId = userId;
  set firstName(String firstName) => publicInfo.firstName = firstName;
  set lastName(String lastName) => publicInfo.lastName = lastName;
  set online(bool online) => publicInfo.online = online;
  set profilePictureUrl(String profilePictureUrl) =>
      publicInfo.profilePictureUrl = profilePictureUrl;
  set bio(String bio) => publicInfo.bio = bio;
  set lastOnlineTimestamp(dynamic lastOnlineTimestamp) =>
      publicInfo.lastOnlineTimestamp = lastOnlineTimestamp;
  set gender(String? gender) => publicInfo.gender = gender;

  // Private
  String get email => privateInfo.email;
  String get mobile => privateInfo.mobile;
  DateTime get birthday => privateInfo.birthday;
  bool get notificationsEnabled => privateInfo.notificationsEnabled;
  String get recentIp => privateInfo.recentIp;
  String get signupIp => privateInfo.signupIp;
  String get recentPlatform => privateInfo.recentPlatform;
  dynamic get signupTimestamp => privateInfo.signupTimestamp;
  Location? get recentLocation => privateInfo.recentLocation;
  Location? get signupLocation => privateInfo.signupLocation;

  set email(String email) => privateInfo.email = email;
  set mobile(String mobile) => privateInfo.mobile = mobile;
  set birthday(DateTime birthday) => privateInfo.birthday = birthday;
  set notificationsEnabled(bool notificationsEnabled) =>
      privateInfo.notificationsEnabled = notificationsEnabled;
  set recentIp(String recentIp) => privateInfo.recentIp = recentIp;
  set signupIp(String signupIp) => privateInfo.signupIp = signupIp;
  set recentPlatform(String recentPlatform) =>
      privateInfo.recentPlatform = recentPlatform;
  set signupTimestamp(dynamic signupTimestamp) => privateInfo.signupTimestamp;
  set recentLocation(Location? recentLocation) =>
      privateInfo.recentLocation = recentLocation;
  set signupLocation(Location? signupLocation) =>
      privateInfo.signupLocation = signupLocation;

  AuthenticatedUser.fromInfo(
      {required this.publicInfo, required this.privateInfo});

  Map<String, dynamic> toPublicJson() => publicInfo.toJson();

  Map<String, dynamic> toPrivateJson() => privateInfo.toJson();
}
