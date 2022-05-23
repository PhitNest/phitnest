import 'package:flutter/material.dart';
import 'package:phitnest/ui/screens/testers.dart';
import 'package:progress_widgets/progress_widgets.dart';

class TestCardWidget extends StatelessWidget {
  final String className;
  final String testName;
  final TestResult result;

  MaterialColor get buttonColor => result.passed ? Colors.green : Colors.red;

  TestCardWidget(
      {Key? key,
      required this.className,
      required this.testName,
      required this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.hovered)
                    ? buttonColor.shade600
                    : buttonColor)),
        onPressed: () => showAlertDialog(
            context,
            "$testName: ${result.passed ? "Passed" : "Failed"}",
            result.message),
        child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Text("$className:$testName")));
  }
}
