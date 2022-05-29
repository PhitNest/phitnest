import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:phitnest/ui/screens/providers.dart';

import 'package:phitnest/main.dart' as app;

extension Swiper on WidgetTester {
  swipe(Offset start, Offset end, Duration duration) async =>
      await startGesture(start).then((gesture) async => await gesture
          .moveTo(end, timeStamp: duration)
          .then((_) async => await gesture.up()));
}

runTest(String testName, Future<void> Function(WidgetTester tester) test) {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group(
      'Integration Test:',
      () => testWidgets(testName, (tester) async {
            await app.main();
            await tester.pumpAndSettle();

            expect(find.byType(OnBoardingProvider), findsOneWidget,
                reason:
                    "The on boarding screen should always be the first screen.");
            await test(tester);
          }));
}
