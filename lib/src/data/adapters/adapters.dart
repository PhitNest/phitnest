import 'package:get_it/get_it.dart';

import 'implementations/http.adapter.dart';
import 'interfaces/http.adapter.dart';

final adapters = GetIt.instance;

void injectAdapters() {
  adapters.registerSingleton<IHttpAdapter>(DioHttpAdapter());
}

IHttpAdapter get httpAdapter => adapters();
