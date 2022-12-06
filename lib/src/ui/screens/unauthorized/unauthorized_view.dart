import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_mobile/src/ui/widgets/styled_button.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class UnauthorizedView extends ScreenView {
  final VoidCallback onRegister;
  final VoidCallback onSignIn;

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
                style: theme.textTheme.headlineLarge,
              ),
              40.verticalSpace,
              SizedBox(
                width: 291.w,
                child: Text(
                  'Please sign-in or register before sending a friend request!',
                  style: theme.textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              40.verticalSpace,
              StyledButton(
                onPressed: onRegister,
                child: Text('REGISTER'),
              ),
              Expanded(child: Container()),
              TextButtonWidget(
                onPressed: onSignIn,
                text: 'SIGN IN',
              ),
              40.verticalSpace,
            ],
          ),
        ),
      );
}
