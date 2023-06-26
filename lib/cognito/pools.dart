part of 'cognito.dart';

const kAdminPoolIdJsonKey = 'adminPoolId';
const kUserPoolIdJsonKey = 'userPoolId';
const kAdminClientIdJsonKey = 'adminClientId';
const kUserClientIdJsonKey = 'userClientId';
const kUserIdentityPoolJsonKey = 'userIdentityPoolId';

class Pools extends JsonSerializable with EquatableMixin {
  final CognitoUserPool adminPool;
  final CognitoUserPool userPool;
  final String identityPoolId;
  final String userBucketName;

  const Pools({
    required this.adminPool,
    required this.userPool,
    required this.identityPoolId,
    required this.userBucketName,
  }) : super();

  @override
  Map<String, Serializable> toJson() => {
        kAdminPoolIdJsonKey: Serializable.string(adminPool.getUserPoolId()),
        kUserPoolIdJsonKey: Serializable.string(userPool.getUserPoolId()),
        kAdminClientIdJsonKey: Serializable.string(adminPool.getClientId()!),
        kUserClientIdJsonKey: Serializable.string(userPool.getClientId()!),
        kUserIdentityPoolJsonKey: Serializable.string(identityPoolId),
        kUserBucketJsonKey: Serializable.string(userBucketName),
      };

  factory Pools.fromJson(dynamic json) => switch (json) {
        {
          kUserPoolIdJsonKey: final String userPoolId,
          kUserClientIdJsonKey: final String userClientId,
          kAdminClientIdJsonKey: final String adminClientId,
          kAdminPoolIdJsonKey: final String adminPoolId,
          kUserIdentityPoolJsonKey: final String identityPoolId,
          kUserBucketJsonKey: final String userBucketName,
        } =>
          Pools(
            adminPool: CognitoUserPool(
              adminPoolId,
              adminClientId,
              storage: _SecureCognitoStorage(),
            ),
            userPool: CognitoUserPool(
              userPoolId,
              userClientId,
              storage: _SecureCognitoStorage(),
            ),
            identityPoolId: identityPoolId,
            userBucketName: userBucketName,
          ),
        _ => throw FormatException(
            'Invalid JSON for _CognitoDetails',
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
      ];
}

const kPoolsJsonKey = 'cognitoDetails';

Future<void> _cachePools(
  Pools? details,
) =>
    cacheObject(
      kPoolsJsonKey,
      details,
    );

Pools? _getCachedPools() => getCachedObject(
      kPoolsJsonKey,
      Pools.fromJson,
    );

Future<HttpResponse<Pools>> _requestPools() => request(
      route: '/info',
      method: HttpMethod.get,
      parser: Pools.fromJson,
    ).then(
      (res) async {
        if (res is HttpResponseOk<Pools>) {
          await _cachePools(res.data);
        }
        return res;
      },
    );
