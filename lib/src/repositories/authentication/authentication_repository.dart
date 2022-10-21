import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

import '../../constants/constants.dart';
import '../repositories.dart';

class AuthenticationRepository extends Repository {
  bool rememberMe = true;

  String? _refreshToken;
  DateTime? _refreshExpiry;
  String? _userId;

  String? get userId => _userId;

  Map<String, dynamic> get authHeaders => {'Authorization': _refreshToken};

  bool get isAuthenticated =>
      _refreshExpiry != null && _refreshExpiry!.isAfter(DateTime.now());

  signOut() {
    _refreshToken = null;
    _refreshExpiry = null;
    _userId = null;
    repositories<DeviceCacheRepository>().cacheRefreshToken(null);
    repositories<DeviceCacheRepository>().cacheEmail(null);
    repositories<DeviceCacheRepository>().cachePassword(null);
  }

  _cacheLoginCredentials(String refreshToken, String email, String password) =>
      repositories<DeviceCacheRepository>()
          .cacheRefreshToken(refreshToken)
          .then(() => repositories<DeviceCacheRepository>()
              .cacheEmail(email)
              .then(() => repositories<DeviceCacheRepository>()
                  .cachePassword(password)));

  Future<String?> login(String email, String password) => http
          .post(repositories<EnvironmentRepository>().getBackendAddress(kLogin,
              params: {'email': email, 'password': password}))
          .then((response) {
        if (response.statusCode == kStatusOK) {
          try {
            _refreshToken = response.body;
            _refreshExpiry = Jwt.getExpiryDate(response.body);
            _userId = Jwt.parseJwt(response.body)['id'];
            if (rememberMe) {
              _cacheLoginCredentials(response.body, email, password);
            }
            return null;
          } catch (ignored) {}
        }
        return response.body;
      });

  Future<String?> loginWithCache() async {
    String? refreshToken = repositories<DeviceCacheRepository>().refreshToken;
    if (refreshToken != null) {
      DateTime? exp = Jwt.getExpiryDate(refreshToken);
      if (exp != null && exp.isAfter(DateTime.now())) {
        _refreshExpiry = exp;
        _refreshToken = refreshToken;
        _userId = Jwt.parseJwt(refreshToken)['id'];
        return null;
      }
    }
    List<String?> credentials = ([
      repositories<DeviceCacheRepository>().email,
      repositories<DeviceCacheRepository>().password
    ]);
    if (credentials[0] != null && credentials[1] != null) {
      return login(credentials[0]!, credentials[1]!);
    }
    return "No cached login credentials found.";
  }
}
