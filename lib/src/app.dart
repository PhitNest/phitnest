import 'package:flutter/material.dart';

import 'presentation/theme.dart';
import 'presentation/widgets/widgets.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      // To use DevicePreview, add an entry to your .env file with the name of the device you want to use.
      // The available devices are listed in the example .env files.
      DevicePreviewProvider(
        builder: (context, usingDevicePreview) => MaterialApp(
          title: 'PhitNest',
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: Scaffold(body: Container()),
        ),
      );
}
