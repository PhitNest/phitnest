import '../location/location_model.dart';
import 'user_settings_model.dart';

class UserModel {
  String userID;
  String email;
  String firstName;
  String lastName;
  bool online;
  UserSettings settings;
  int lastOnlineTimestamp;
  String recentPlatform;
  String? mobile;
  Location? recentLocation;
  Location? signupLocation;
  String recentIP;
  String signupIP;

  String get fullName => '$firstName${lastName == '' ? '' : ' '}$lastName';

  UserModel({
    required this.userID,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.online,
    required this.lastOnlineTimestamp,
    required this.settings,
    required this.recentPlatform,
    required this.recentIP,
    required this.signupIP,
    this.recentLocation,
    this.signupLocation,
    this.mobile,
  });

  factory UserModel.fromJson(Map<String, dynamic> parsedJson) => UserModel(
      userID: parsedJson['userID'],
      email: parsedJson['email'],
      firstName: parsedJson['firstName'],
      lastName: parsedJson['lastName'],
      recentIP: parsedJson['recentIP'],
      signupIP: parsedJson['signupIP'],
      recentPlatform: parsedJson['recentPlatform'],
      online: parsedJson['online'],
      lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
      settings: UserSettings.fromJson(parsedJson['settings']),
      // nullables
      mobile: parsedJson['mobile'],
      recentLocation: Location.fromJson(parsedJson['recentLocation']),
      signupLocation: Location.fromJson(parsedJson['signupLocation']));

  Map<String, dynamic> toJson() {
    // Cover the requireds
    Map<String, dynamic> json = {
      'userID': userID,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'online': online,
      'settings': settings.toJson(),
      'lastOnlineTimestamp': lastOnlineTimestamp,
      'recentPlatform': recentPlatform,
      'signupIP': signupIP,
      'recentIP': recentIP,
    };

    // nullables
    if (this.mobile != null) {
      json['mobile'] = mobile;
    }

    if (this.recentLocation != null) {
      json['recentLocation'] = recentLocation!.toJson();
    }

    if (this.signupLocation != null) {
      json['signupLocation'] = signupLocation!.toJson();
    }

    return json;
  }
}
