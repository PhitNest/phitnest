import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';
import '../../../widgets/widgets.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            64.verticalSpace,
            Text(
              'Reset Password',
              style: AppTheme.instance.theme.textTheme.bodyLarge,
            ),
            32.verticalSpace,
            Form(
              child: Column(
                children: [
                  StyledTextFormField(labelText: 'Email'),
                  24.verticalSpace,
                  StyledTextFormField(labelText: 'New Password'),
                  24.verticalSpace,
                  StyledTextFormField(labelText: 'Confirm New Password'),
                ],
              ),
            ),
            23.verticalSpace,
            Center(
              child: ElevatedButton(
                onPressed: () => {},
                child: Text(
                  'RESET PASSWORD',
                  style: AppTheme.instance.theme.textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
