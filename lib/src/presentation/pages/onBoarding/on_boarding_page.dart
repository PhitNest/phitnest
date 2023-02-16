import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';
import '../../widgets/styled/styled.dart';
import '../pages.dart';

class OnBoardingPage extends StatelessWidget {
  /// POP RESULT: NONE
  const OnBoardingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: 1.sh,
            width: double.infinity,
            child: Column(
              children: [
                120.verticalSpace,
                Text(
                  "It takes a village\nto live a healthy life",
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                40.verticalSpace,
                Text(
                  "Meet people at your fitness club.\nAchieve your goals together.\nLive a healthy life!",
                  style: theme.textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                StyledButton(
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const RegistrationPage(),
                    ),
                  ),
                  text: "LET'S GET STARTED",
                ),
                12.verticalSpace,
                StyledUnderlinedTextButton(
                  text: 'SIGN IN',
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ),
                ),
                120.verticalSpace,
              ],
            ),
          ),
        ),
      );
}
