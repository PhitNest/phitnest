import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as testHarness;

import 'package:phitnest/main.dart' as app;

import 'package:phitnest/ui/screens/views.dart';
import 'package:phitnest/ui/screens/providers.dart';

import 'test_base.dart';

const Duration swipeLength = Duration(milliseconds: 400);

extension OnBoardingTest on testHarness.WidgetTester {
  completeOnBoardingScreen() async {
    // Get the number of pages in the on boarding screen
    int numPages =
        widget<OnBoardingView>(testHarness.find.byType(OnBoardingView))
            .numPages;

    // Swipe through each page of the on boarding screen
    for (int swipeNum = 0; swipeNum < numPages - 1; swipeNum++) {
      await swipe(Offset(200, 200), Offset(0, 200), swipeLength);
      await pumpAndSettle();

      testHarness.Finder continueButtonFinder =
          testHarness.find.byKey(Key("onboarding_continue"));

      if (swipeNum != numPages - 2) {
        testHarness.expect(continueButtonFinder, testHarness.findsNothing,
            reason:
                "The continue button should not be visible until the final page.");
      } else {
        testHarness.expect(continueButtonFinder, testHarness.findsOneWidget,
            reason: "The continue button should be visible on the last page.");
        await tap(continueButtonFinder);
      }
    }
    await pumpAndSettle();

    testHarness.expect(
        testHarness.find.byType(AuthProvider), testHarness.findsOneWidget,
        reason:
            "After completing the on boarding screen you should be directed to the auth screen.");
  }
}

void main() {
  runTest('On Boarding Screen', (tester) async {
    // Immeditately restart the app without completing the onboarding screen.
    // Since we did not complete the on boarding, it should show again when we
    // restart the app.
    await app.restartTestApp();

    // Whenever you restart the app, you should do pump and settle twice.
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    testHarness.expect(
        testHarness.find.byType(OnBoardingProvider), testHarness.findsOneWidget,
        reason:
            "When you restart the app without completing the on boarding screen, it should be shown again.");

    // Make sure you can't navigate too far to the left
    await tester.swipe(Offset(100, 200), Offset(300, 200), swipeLength);

    await tester.pumpAndSettle();

    await tester.completeOnBoardingScreen();

    // Restart the app to verify that it does not show the on boarding screen
    // again once completed.
    await app.restartTestApp();

    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    testHarness.expect(
        testHarness.find.byType(AuthProvider), testHarness.findsOneWidget,
        reason:
            "When you restart the app after completing the on boarding screen, the authentication screen should be shown.");
  });
}
