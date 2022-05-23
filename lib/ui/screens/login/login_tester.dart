import '../testers.dart';

class LoginTester extends BaseTester {
  @override
  List<TestResult Function()> get testCases => [
        testView,
        testSomething,
        testStuff,
        testStuff2,
        testStuff3,
        testStuff4,
        testStuff5,
      ];

  TestResult testView() {
    return TestResult("Test testcase", true);
  }

  TestResult testSomething() {
    return TestResult("Fail this test :(", false);
  }

  TestResult testStuff() {
    return TestResult("Fail this test :(", false);
  }

  TestResult testStuff2() {
    return TestResult("Fail this test :(", false);
  }

  TestResult testStuff3() {
    return TestResult("Fail this test :(", false);
  }

  TestResult testStuff4() {
    return TestResult("Fail this test :(", false);
  }

  TestResult testStuff5() {
    return TestResult("Fail this test :(", false);
  }
}
