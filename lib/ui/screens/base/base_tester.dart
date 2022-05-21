abstract class BaseTester {
  List<TestResult Function()> get testCases;

  Stream<TestResult> runTests() async* {
    for (TestResult Function() testCase in testCases) {
      yield testCase();
    }
  }
}

class TestResult {
  String message;
  bool passed;

  TestResult(this.message, this.passed);

  @override
  String toString() {
    return "${passed ? "Passed" : "Failed"}: $message";
  }
}
