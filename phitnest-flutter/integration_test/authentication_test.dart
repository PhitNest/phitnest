import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:phitnest/ui/screens/screens.dart';

import 'on_boarding_test.dart';
import 'test_base.dart';

void main() {
  runTest('Authentication Screen', (tester) async {
    // Go through the on boarding screen
    await tester.completeOnBoardingScreen();

    // There shouldn't be a back button on the auth screen
    expect(backButtonFinder, findsNothing,
        reason: "There should be no back button on the authentication screen.");

    Finder signInButtonFinder = find.byKey(Key("auth_signIn"));
    Finder registerButtonFinder = find.byKey(Key("auth_register"));

    // There should be a sign in button
    expect(signInButtonFinder, findsOneWidget,
        reason: "There should be a button with key \"auth_signIn\"");

    // There should be a register button
    expect(registerButtonFinder, findsOneWidget,
        reason: "There should be a button with key \"auth_register\"");

    // Tap the sign in button
    await tester.tap(signInButtonFinder);
    await tester.pumpAndSettle();

    // We should be on the sign in screen
    expect(find.byType(SignInProvider), findsOneWidget,
        reason:
            "Pressing the sign in button should take you to the sign in screen.");

    // There should be a back button to get back to the auth screen
    expect(backButtonFinder, findsOneWidget,
        reason: "Cannot return to auth screen from sign in screen.");

    // Tap the back button
    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();

    // We should be back on the auth screen
    expect(find.byType(AuthProvider), findsOneWidget,
        reason:
            "The auth screen should be returned to after pressing back from sign in screen.");

    // Tap the register button
    await tester.tap(registerButtonFinder);
    await tester.pumpAndSettle();

    // We should be on the register screen
    expect(find.byType(RegisterProvider), findsOneWidget,
        reason:
            "Pressing the sign in button should take you to the register screen.");

    // There should be a back button to return to the auth screen
    expect(backButtonFinder, findsOneWidget,
        reason: "Cannot return to auth screen from register screen.");

    // Tap the back button
    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();

    // We should be back on the auth screen
    expect(find.byType(AuthProvider), findsOneWidget,
        reason:
            "The auth screen should be returned to after pressing back from register screen.");
  });
}
