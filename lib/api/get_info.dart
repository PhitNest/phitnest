part of 'api.dart';

const kAdminPoolIdJsonKey = 'adminPoolId';
const kUserPoolIdJsonKey = 'userPoolId';
const kAdminClientIdJsonKey = 'adminClientId';
const kUserClientIdJsonKey = 'userClientId';
const kUserIdentityPoolJsonKey = 'userIdentityPoolId';
const kUserBucketJsonKey = 'userBucketName';

final class ApiInfo extends JsonSerializable {
  final CognitoUserPool userPool;
  final CognitoUserPool adminPool;
  final String identityPoolId;
  final String userBucketName;
  final bool useAdmin;

  const ApiInfo({
    required this.userPool,
    required this.adminPool,
    required this.identityPoolId,
    required this.userBucketName,
    required this.useAdmin,
  }) : super();

  CognitoUserPool get pool => useAdmin ? adminPool : userPool;

  @override
  Map<String, Serializable> toJson() => {
        kAdminPoolIdJsonKey: Serializable.string(adminPool.getUserPoolId()),
        kUserPoolIdJsonKey: Serializable.string(userPool.getUserPoolId()),
        kAdminClientIdJsonKey: Serializable.string(adminPool.getClientId()!),
        kUserClientIdJsonKey: Serializable.string(userPool.getClientId()!),
        kUserIdentityPoolJsonKey: Serializable.string(identityPoolId),
        kUserBucketJsonKey: Serializable.string(userBucketName),
      };

  factory ApiInfo.fromJson(dynamic json, bool useAdmin) => switch (json) {
        {
          kUserPoolIdJsonKey: final String userPoolId,
          kUserClientIdJsonKey: final String userClientId,
          kAdminClientIdJsonKey: final String adminClientId,
          kAdminPoolIdJsonKey: final String adminPoolId,
          kUserIdentityPoolJsonKey: final String identityPoolId,
          kUserBucketJsonKey: final String userBucketName,
        } =>
          ApiInfo(
            adminPool: CognitoUserPool(
              adminPoolId,
              adminClientId,
              storage: SecureCognitoStorage(),
            ),
            userPool: CognitoUserPool(
              userPoolId,
              userClientId,
              storage: SecureCognitoStorage(),
            ),
            identityPoolId: identityPoolId,
            userBucketName: userBucketName,
            useAdmin: useAdmin,
          ),
        _ => throw FormatException(
            'Invalid JSON for ApiInfo',
            json,
          ),
      };

  @override
  List<Object?> get props => [
        adminPool.getUserPoolId(),
        adminPool.getClientId(),
        userPool.getUserPoolId(),
        userPool.getClientId(),
        userBucketName,
        identityPoolId,
        useAdmin,
      ];
}

const kApiInfoCacheKey = 'apiInfo';

Future<void> cacheApiInfo(
  ApiInfo? details,
) =>
    cacheObject(
      kApiInfoCacheKey,
      details,
    );

ApiInfo? getCachedApiInfo(bool admin) => getCachedObject(
      kApiInfoCacheKey,
      (json) => ApiInfo.fromJson(json, admin),
    );

Future<HttpResponse<ApiInfo>> requestApiInfo({
  required bool writeToCache,
  required bool readFromCache,
  required bool useAdmin,
}) =>
    request(
      route: '/info',
      method: HttpMethod.get,
      parser: (json) => ApiInfo.fromJson(json, useAdmin),
      writeToCache: writeToCache ? cacheApiInfo : null,
      readFromCache: readFromCache ? () => getCachedApiInfo(useAdmin) : null,
    );
