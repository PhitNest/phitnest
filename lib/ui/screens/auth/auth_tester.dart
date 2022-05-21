import '../testers.dart';

class AuthTester extends BaseTester {
  @override
  List<TestResult Function()> get testCases => [
        testView,
      ];

  TestResult testView() {
    return TestResult("Test testcase", true);
  }
}
