abstract class BaseTester {
  List<Function> get testCases;

  Stream<MapEntry<String, TestResult>> runTests() async* {
    for (Function testCase in testCases) {
      yield MapEntry(
          testCase
              .toString()
              .split(' ')
              .last
              .replaceAll('\'', '')
              .replaceAll(':.', ''),
          testCase());
    }
  }
}

class TestResult {
  String message;
  bool passed;

  TestResult(this.message, this.passed);
}
