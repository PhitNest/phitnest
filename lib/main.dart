import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/repositories/repositories.dart';
import 'src/services/services.dart';
import 'src/use-cases/use_cases.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  injectServices();
  injectRepositories();
  injectUseCases();
  runApp(
    App(),
  );
}
