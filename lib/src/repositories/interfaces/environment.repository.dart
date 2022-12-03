abstract class IEnvironmentRepository {
  Uri getBackendAddress(String route, {Map<String, dynamic>? params});
  String get(String key);
}
