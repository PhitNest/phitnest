import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as testHarness;

import 'package:phitnest/main.dart' as app;

import 'on_boarding_test.dart';
import 'test_base.dart';

void main() {
  runTest('Authentication Screen', (tester) async {
    await tester.completeOnBoardingScreen();
  });
}
