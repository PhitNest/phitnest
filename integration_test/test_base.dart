import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:phitnest/ui/screens/screens.dart';

import 'package:phitnest/main.dart' as app;

extension Restart on WidgetTester {
  restart() async {
    await app.restartTestApp();
    await pumpAndSettle();
    await pumpAndSettle();
  }
}

extension Swiper on WidgetTester {
  swipe(Offset start, Offset end, Duration duration) async =>
      await startGesture(start).then((gesture) async => await gesture
          .moveTo(end, timeStamp: duration)
          .then((_) async => await gesture.up()));
}

Finder backButtonFinder = find.byKey(Key("backButton"));

runTest(String testName, Future<void> Function(WidgetTester tester) test) {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group(
      'Integration Test:',
      () => testWidgets(testName, (tester) async {
            // Make sure we don't use device preview for integration tests
            app.usePreview = false;
            await app.main();
            await tester.pumpAndSettle();

            await test(tester);
          }));
}
