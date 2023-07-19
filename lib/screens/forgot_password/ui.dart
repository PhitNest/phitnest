import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/styled_text_form_field.dart';
import 'widgets/confirm_email.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
              'Forgot Password?',
              style: AppTheme.instance.theme.textTheme.bodyLarge,
            ),
            32.verticalSpace,
            Text(
              'Enter your email address',
              style: AppTheme.instance.theme.textTheme.bodyMedium,
            ),
            16.verticalSpace,
            Form(
              child: StyledTextFormField(
                labelText: 'Email',
              ),
            ),
            23.verticalSpace,
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (context) => const ConfirmEmailScreen(),
                  ),
                ),
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
