import '../models.dart';

class UserModel {
  UserPublicInfo publicInfo;
  UserPrivateInfo privateInfo;

  // Public
  String get userId => publicInfo.userId;
  String get firstName => publicInfo.firstName;
  String get lastName => publicInfo.lastName;
  bool get online => publicInfo.online;
  String get profilePictureUrl => publicInfo.profilePictureUrl;
  String get bio => publicInfo.bio;
  int get lastOnlineTimestamp => publicInfo.lastOnlineTimestamp;
  String? get gender => publicInfo.gender;

  String get fullName => publicInfo.fullName;

  set userId(String userId) => publicInfo.userId = userId;
  set firstName(String firstName) => publicInfo.firstName = firstName;
  set lastName(String lastName) => publicInfo.lastName = lastName;
  set online(bool online) => publicInfo.online = online;
  set profilePictureUrl(String profilePictureUrl) =>
      publicInfo.profilePictureUrl = profilePictureUrl;
  set bio(String bio) => publicInfo.bio = bio;
  set lastOnlineTimestamp(int lastOnlineTimestamp) =>
      publicInfo.lastOnlineTimestamp = lastOnlineTimestamp;
  set gender(String? gender) => publicInfo.gender = gender;

  // Private
  String get email => privateInfo.email;
  String get mobile => privateInfo.mobile;
  String get birthday => privateInfo.birthday;
  bool get notificationsEnabled => privateInfo.notificationsEnabled;
  String get recentIp => privateInfo.recentIp;
  String get signupIp => privateInfo.signupIp;
  String get recentPlatform => privateInfo.recentPlatform;
  Location? get recentLocation => privateInfo.recentLocation;
  Location? get signupLocation => privateInfo.signupLocation;

  set email(String email) => privateInfo.email;
  set mobile(String mobile) => privateInfo.mobile;
  set birthday(String birthday) => privateInfo.birthday;
  set notificationsEnabled(bool notificationsEnabled) =>
      privateInfo.notificationsEnabled;
  set recentIp(String recentIp) => privateInfo.recentIp;
  set signupIp(String signupIp) => privateInfo.signupIp;
  set recentPlatform(String recentPlatform) => privateInfo.recentPlatform;
  set recentLocation(Location? recentLocation) => privateInfo.recentLocation;
  set signupLocation(Location? signupLocation) => privateInfo.signupLocation;

  UserModel.fromInfo({required this.publicInfo, required this.privateInfo});

  Map<String, dynamic> toPublicJson() => publicInfo.toJson();

  Map<String, dynamic> toPrivateJson() => privateInfo.toJson();
}
