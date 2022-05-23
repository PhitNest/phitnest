import 'package:flutter/material.dart';

import 'locator.dart';
import 'ui/common/widgets/widgets.dart';
import 'ui/screens/testers.dart';

class TestApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  List<TestCardWidget> testResultCards = [];

  _TestAppState() : super() {
    testApp().listen((result) => setState(() => testResultCards.add(result)));
  }

  Stream<TestCardWidget> testApp() async* {
    List<BaseTester> testers = locator<List<BaseTester>>();

    for (BaseTester tester in testers) {
      yield* (tester.runTests().map((entry) => TestCardWidget(
            className: tester.runtimeType.toString(),
            testName: entry.key,
            result: entry.value,
          )));
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Phitnest Unit Test Runner',
      home: Scaffold(
          appBar: AppBar(
            title: Text("Unit Test GUI"),
          ),
          body:
              SingleChildScrollView(child: Column(children: testResultCards))));
}
