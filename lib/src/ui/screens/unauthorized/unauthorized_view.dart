import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_mobile/src/ui/common/styled_button.dart';

import '../view.dart';

class UnauthorizedView extends ScreenView {
  final Function() onRegister;
  final Function() onSignIn;

  UnauthorizedView({
    Key? key,
    required this.onRegister,
    required this.onSignIn,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              200.verticalSpace,
              Text(
                'Oh no!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              40.verticalSpace,
              SizedBox(
                width: 291.w,
                child: Text(
                  'Please sign-in or register before sending a friend request!',
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              40.verticalSpace,
              StyledButton(
                onPressed: onRegister,
                child: Text('REGISTER'),
              ),
              205.verticalSpace,
              TextButton(
                onPressed: onSignIn,
                child: Text(
                  'SIGN IN',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        decoration: TextDecoration.underline,
                        color: Color(0xFF000000),
                      ),
                ),
              )
            ],
          ),
        ),
      );
}
