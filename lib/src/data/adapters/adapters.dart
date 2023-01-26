import 'package:get_it/get_it.dart';

import 'implementations/implementations.dart';
import 'interfaces/interfaces.dart';

final adapters = GetIt.instance;

void injectAdapters() {
  adapters.registerSingleton<IHttpAdapter>(DioHttpAdapter());
  adapters.registerSingleton<ISocketIOAdapter>(SocketIOAdapter());
}

IHttpAdapter get httpAdapter => adapters();
ISocketIOAdapter get socketIOAdapter => adapters();
