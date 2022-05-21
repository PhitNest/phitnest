import 'package:flutter/material.dart';

import 'locator.dart';
import 'ui/screens/testers.dart';

class TestApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  Stream<TestResult> testApp() async* {
    List<BaseTester> testers = locator<List<BaseTester>>();

    for (BaseTester tester in testers) {
      yield* tester.runTests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phitnest Unit Test Runner',
      home: Scaffold(),
    );
  }
}
