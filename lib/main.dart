import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/repositories/repositories.dart';
import 'src/use-cases/use_cases.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  injectRepositories();
  injectUseCases();
  runApp(
    App(),
  );
}
