import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';
import '../../widgets/widgets.dart';

const kBackgroundColor = Color(0xFFF5F5F5);

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: StyledBackButton(
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          backgroundColor: kBackgroundColor,
        ),
        body: SizedBox(
          width: 1.sw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              0.verticalSpace,
              Text(
                'Forgot the password?',
                style: theme.textTheme.headlineLarge,
              ),
              42.verticalSpace,
              Text(
                'We’ll send you an email to reset\nyour password.',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge,
              ),
              16.verticalSpace,
              SizedBox(
                width: 45.w,
                child: StyledUnderlinedTextField(
                  hint: 'Email',
                ),
              ),
              // StyledUnderlinedTextField(),
            ],
          ),
        ),
      );
}
