import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../interfaces/interfaces.dart';

class EnvironmentService implements IEnvironmentService {
  static const String kBackendHost = 'BACKEND_HOST';
  static const String kBackendPort = 'BACKEND_PORT';
  static const String kUseHttps = 'USE_HTTPS';

  static Future<void> init() => dotenv.load();

  @override
  String get backendHost => dotenv.get(kBackendHost);

  @override
  String get backendPort => dotenv.get(kBackendPort);

  @override
  bool get useHttps => dotenv.get(kUseHttps) == 'true';
}
