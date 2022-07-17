import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:phitnest/ui/screens/onBoarding/on_boarding_model.dart';
import 'package:phitnest/ui/screens/onBoarding/on_boarding_view.dart';
import 'package:phitnest/ui/screens/screens.dart';

import 'test_base.dart';

const Duration swipeLength = Duration(milliseconds: 400);

extension OnBoardingTest on WidgetTester {
  // Function to get an updated reference to our screen view
  OnBoardingView onBoardingView() =>
      widget<OnBoardingView>(find.byType(OnBoardingView));

  completeOnBoardingScreen() async {
    // Get the number of pages in the on boarding screen
    int numPages = OnBoardingModel.pages.length;

    // Swipe through each page of the on boarding screen
    for (int swipeNum = 0; swipeNum < numPages - 1; swipeNum++) {
      // Swipe right
      await swipe(Offset(200, 200), Offset(0, 200), swipeLength);
      await pumpAndSettle();

      // Check if we are currently on the last page
      if (onBoardingView().controller.currentPage == numPages - 1) {
        // Make sure you can't navigate too far to the right
        await swipe(Offset(200, 200), Offset(0, 200), swipeLength);
        await pumpAndSettle();

        // If we are not still on the last page after an additional swipe, fail
        if (onBoardingView().controller.currentPage != numPages - 1) {
          fail('The screen should not scroll past the last page.');
        }

        // Tap the continue button (this strange predicate function is just finding
        // the first instance of our continue button, because liquid swipes stacks the
        // individual pages ontop of each other so multiple instances of our continue
        // button are found)
        bool foundButton = false;
        await tap(find.byWidgetPredicate((widget) {
          if (!foundButton) {
            if (widget.key == Key('onBoarding_continue')) {
              foundButton = true;
              return true;
            }
          }
          return false;
        }), warnIfMissed: false);
        await pumpAndSettle();
      }
    }

    // After completing the on boarding process you should be redirected to the
    // auth screen
    expect(find.byType(AuthProvider), findsOneWidget,
        reason:
            'After completing the on boarding screen you should be directed to the auth screen.');
  }
}

void main() {
  runTest('On Boarding Screen', (tester) async {
    // Immeditately restart the app without completing the onboarding screen.
    // Since we did not complete the on boarding, it should show again when we
    // restart the app.
    await tester.restart();
    expect(find.byType(OnBoardingProvider), findsOneWidget,
        reason:
            'When you restart the app without completing the on boarding screen, it should be shown again.');

    // Make sure you can't navigate too far to the left
    await tester.swipe(Offset(100, 200), Offset(300, 200), swipeLength);
    await tester.pumpAndSettle();

    // If we are not still on the first page after an additional swipe, fail
    if (tester.onBoardingView().controller.currentPage != 0) {
      fail('The screen should not scroll past the first page.');
    }

    // Complete the on boarding process
    await tester.completeOnBoardingScreen();

    // Restart the app to verify that it does not show the on boarding screen
    // again once completed.
    await tester.restart();

    // We should be on the auth screen upon startup
    expect(find.byType(AuthProvider), findsOneWidget,
        reason:
            'When you restart the app after completing the on boarding screen, the authentication screen should be shown.');
  });
}
