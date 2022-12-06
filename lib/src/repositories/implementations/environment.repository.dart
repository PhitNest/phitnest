import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../interfaces/interfaces.dart';

class EnvironmentRepository implements IEnvironmentRepository {
  static const String kBackendHost = 'BACKEND_HOST';
  static const String kBackendPort = 'BACKEND_PORT';

  static Future<void> init() => dotenv.load();

  @override
  String get backendHost => dotenv.get(kBackendHost);

  @override
  String get backendPort => dotenv.get(kBackendPort);
}
