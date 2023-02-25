part of cache;

class _DirectMessageCache {
  static const kGetDirectMessages = 'directMessage';

  const _DirectMessageCache();

  List<DirectMessageEntity>? getDirectMessages(String friendCognitoId) =>
      getCachedList(
          '$kGetDirectMessages.$friendCognitoId', DirectMessageEntity.fromJson);

  Future<void> cacheDirectMessages(
    List<DirectMessageEntity>? directMessage,
    String friendCognitoId,
  ) =>
      cacheList('$kGetDirectMessages.$friendCognitoId', directMessage);
}
