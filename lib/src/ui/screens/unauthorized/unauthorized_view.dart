import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';

class UnauthorizedView extends StatelessWidget {
  final VoidCallback onPressedRegister;
  final VoidCallback onPressedLogin;

  const UnauthorizedView({
    required this.onPressedRegister,
    required this.onPressedLogin,
  }) : super();

  @override
  Widget build(BuildContext context) => BetterScaffold(
        body: Column(
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
              onPressed: onPressedRegister,
              child: Text('REGISTER'),
            ),
            Spacer(),
            TextButtonWidget(
              onPressed: onPressedLogin,
              text: 'SIGN IN',
            ),
            40.verticalSpace,
          ],
        ),
      );
}
