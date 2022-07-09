import '../models.dart';

class UserPrivateInfo {
  String email;
  String mobile;
  dynamic birthday;
  bool notificationsEnabled;
  String recentIp;
  String signupIp;
  String recentPlatform;
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
      this.recentLocation,
      this.signupLocation});

  factory UserPrivateInfo.fromJson(Map<String, dynamic> parsedJson) =>
      UserPrivateInfo(
        email: parsedJson['email'],
        mobile: parsedJson['mobile'],
        birthday: parsedJson['birthday'],
        notificationsEnabled: parsedJson['notificationsEnabled'],
        recentIp: parsedJson['recentIp'],
        signupIp: parsedJson['signupIp'],
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
