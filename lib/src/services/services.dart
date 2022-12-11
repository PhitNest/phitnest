import 'package:get_it/get_it.dart';

import 'implementations/implementations.dart';
import 'interfaces/interfaces.dart';

final repositories = GetIt.instance;

Future<void> setup() async {
  await EnvironmentService.init();
}

final services = GetIt.instance;

void injectServices() {
  services.registerSingleton<IEnvironmentService>(EnvironmentService());
  services.registerSingleton<IEventService>(EventService());
  services.registerSingleton<IRestService>(RestService());
}

IEnvironmentService get environmentService => services();
IEventService get eventService => services();
IRestService get restService => services();
