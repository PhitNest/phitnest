import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../repository.dart';

class EnvironmentRepository extends Repository {
  static const String kBackendHost = 'BACKEND_HOST';
  static const String kBackendPort = 'BACKEND_PORT';

  loadEnvironmentVariables() => dotenv.load();

  String get(String key) => dotenv.get(key);

  Uri getBackendAddress(String route, {Map<String, dynamic>? params}) =>
      Uri.http('${get(kBackendHost)}:${get(kBackendPort)}', route, params);
}
