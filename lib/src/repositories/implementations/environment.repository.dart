import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../interfaces/interfaces.dart';

class EnvironmentRepository implements IEnvironmentRepository {
  static const String kBackendHost = 'BACKEND_HOST';
  static const String kBackendPort = 'BACKEND_PORT';

  static Future<void> init() => dotenv.load();

  @override
  String get(String key) => dotenv.get(key);

  @override
  Uri getBackendAddress(String route, {Map<String, dynamic>? params}) =>
      Uri.http('${get(kBackendHost)}:${get(kBackendPort)}', route, params);
}
