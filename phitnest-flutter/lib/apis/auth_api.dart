import 'package:device/device.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class AuthApi {
  static AuthApi instance = AuthApi();

  String? get userId =>
      _refreshToken != null ? Jwt.parseJwt(_refreshToken!)['_id'] : null;

  String? _refreshToken;

  Future<bool> isAuthenticated() async {
    if (_refreshToken != null) {
      if (Jwt.isExpired(_refreshToken!)) {
        return await _loginFromCache();
      }
      return true;
    }
    _refreshToken = await deviceStorage.read(key: kRefreshTokenCache);
    if (_refreshToken != null && !Jwt.isExpired(_refreshToken!)) {
      return true;
    }
    return await _loginFromCache();
  }

  Future<bool> _loginFromCache() async {
    String? email = await deviceStorage.read(key: kEmailCache);
    String? password = await deviceStorage.read(key: kPasswordCache);
    if (email != null && password != null) {
      return await login(email, password) == null;
    }
    return false;
  }

  /// Use this for authenticated requests
  Map<String, String>? get requestHeaders =>
      _refreshToken != null ? {'Authorization': _refreshToken ?? ''} : {};

  /// Return an error if unsuccessful
  Future<String?> login(String email, String password) =>
      http.post(Uri.parse('$kBackEndUrl/auth/login'),
          body: {"email": email, "password": password}).then((res) async {
        if (res.statusCode == 200) {
          await Future.wait([
            deviceStorage.write(key: kRefreshTokenCache, value: res.body),
            deviceStorage.write(key: kEmailCache, value: email),
            deviceStorage.write(key: kPasswordCache, value: password),
          ]);
          _refreshToken = res.body;
          return null;
        } else {
          return res.body;
        }
      });

  /// Retun an error if unsuccessful
  Future<String?> register(String email, String password, String mobile,
          DateTime birthday, String firstName, String? lastName) =>
      http.post(Uri.parse('$kBackEndUrl/auth/register'), body: {
        "email": email,
        "password": password,
        "mobile": mobile,
        "firstName": firstName,
        "birthday": birthday,
        ...(lastName != null ? {"lastName": lastName} : {}),
      }).then((res) async {
        if (res.statusCode == 200) {
          await Future.wait([
            deviceStorage.write(key: kRefreshTokenCache, value: res.body),
            deviceStorage.write(key: kEmailCache, value: email),
            deviceStorage.write(key: kPasswordCache, value: password),
          ]);
          _refreshToken = res.body;
          return null;
        } else {
          return res.body;
        }
      });
}
