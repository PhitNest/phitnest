import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';
import '../../../widgets/widgets.dart';
import 'reset_password.dart';

class ConfirmEmailScreen extends StatelessWidget {
  const ConfirmEmailScreen({
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              120.verticalSpace,
              Text(
                'Verify your email',
                style: AppTheme.instance.theme.textTheme.bodyLarge,
              ),
              52.verticalSpace,
              Center(
                child: StyledVerificationField(
                  onChanged: (value) {},
                  onCompleted: (value) {},
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                ),
              ),
              16.verticalSpace,
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (context) => const ResetPasswordScreen(),
                    ),
                  ),
                  child: Text(
                    'RESEND CODE',
                    style: AppTheme.instance.theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
