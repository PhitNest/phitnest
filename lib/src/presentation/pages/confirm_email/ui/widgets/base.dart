import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/theme.dart';
import '../../../../widgets/styled/styled.dart';

class ConfirmEmailBaseWidget extends StatelessWidget {
  final String email;
  final Widget child;
  final TextEditingController codeController;
  final FocusNode codeFocusNode;
  final VoidCallback onChanged;
  final VoidCallback onCompleted;

  const ConfirmEmailBaseWidget({
    Key? key,
    required this.email,
    required this.child,
    required this.onChanged,
    required this.onCompleted,
    required this.codeController,
    required this.codeFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: 1.sh,
            child: Column(
              children: [
                40.verticalSpace,
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: StyledBackButton(
                      onPressed: () => Navigator.of(context).pop()),
                ),
                30.verticalSpace,
                Text(
                  "Please confirm\nthat it's you.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge,
                ),
                40.verticalSpace,
                Text(
                  "Check $email for a verification\ncode from us and enter it below",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge,
                ),
                60.verticalSpace,
                StyledVerificationField(
                  controller: codeController,
                  focusNode: codeFocusNode,
                  onChanged: (_) => onChanged,
                  onCompleted: (_) => onCompleted,
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      );
}
