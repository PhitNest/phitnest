part of 'api.dart';

final class CognitoPoolInfo extends Json {
  final poolIdJson = Json.string('poolId');
  final clientIdJson = Json.string('clientId');

  String get poolId => poolIdJson.value;
  String get clientId => clientIdJson.value;

  CognitoPoolInfo.parser() : super();

  CognitoPoolInfo.populated(String poolId, String clientId) : super() {
    poolIdJson.populate(poolId);
    clientIdJson.populate(clientId);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [poolIdJson, clientIdJson];
}

final class ApiInfo extends Json {
  final userPoolJson = JsonObjectKey.parser('userPool', CognitoPoolInfo.parser);
  final adminPoolJson =
      JsonObjectKey.parser('adminPool', CognitoPoolInfo.parser);
  final identityPoolIdJson = Json.string('identityPoolId');
  final userBucketNameJson = Json.string('userBucketName');
  final bool useAdmin;

  late final CognitoUserPool _userPool = _pool(userPoolJson.value);
  late final CognitoUserPool _adminPool = _pool(adminPoolJson.value);

  CognitoUserPool get userPool => _userPool;
  CognitoUserPool get adminPool => _adminPool;
  String get identityPoolId => identityPoolIdJson.value;
  String get userBucketName => userBucketNameJson.value;

  CognitoUserPool _pool(CognitoPoolInfo info) => CognitoUserPool(
        info.poolId,
        info.clientId,
        storage: SecureCognitoStorage(),
      );

  ApiInfo.parse(Map<String, dynamic> json, this.useAdmin) : super.parse(json);

  ApiInfo.parser(this.useAdmin) : super();

  CognitoUserPool get pool => useAdmin ? adminPool : userPool;

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [
        userPoolJson,
        adminPoolJson,
        identityPoolIdJson,
        userBucketNameJson,
      ];

  @override
  List<Object?> get props => [...super.props, useAdmin];
}

const kApiInfoJsonKey = 'apiInfo';

Future<void> cacheApiInfo(
  ApiInfo? details,
) =>
    cacheObject(kApiInfoJsonKey, details);

ApiInfo? getCachedApiInfo(bool admin) =>
    getCachedObject(kApiInfoJsonKey, () => ApiInfo.parser(admin));

Future<HttpResponse<ApiInfo>> requestApiInfo({
  required bool writeToCache,
  required bool readFromCache,
  required bool useAdmin,
}) =>
    request(
      route: '/info',
      method: HttpMethod.get,
      parse: (json) => ApiInfo.parse(json, useAdmin),
      writeToCache: writeToCache ? cacheApiInfo : null,
      readFromCache: readFromCache ? () => getCachedApiInfo(useAdmin) : null,
    );
