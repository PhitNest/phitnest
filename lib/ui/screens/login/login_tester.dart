import '../testers.dart';

class LoginTester extends BaseTester {
  @override
  List<TestResult Function()> get testCases => [
        testView,
        testSomething,
      ];

  TestResult testView() {
    return TestResult("Test testcase", true);
  }

  TestResult testSomething() {
    return TestResult("Fail this test :(", false);
  }
}
