import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../../common/util.dart';
import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../confirm_email/ui.dart';
import 'bloc/bloc.dart';

part 'pages/account_info.dart';
part 'pages/inviter_email.dart';
part 'pages/loading.dart';
part 'pages/name.dart';

void _nextPage(BuildContext context) =>
    context.registerBloc.pageController.nextPage(
      duration: const Duration(
        milliseconds: 400,
      ),
      curve: Curves.easeInOut,
    );

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider(
          create: (_) => RegisterBloc(),
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, screenState) {},
            builder: (context, screenState) =>
                BlocConsumer<CognitoBloc, CognitoState>(
              listener: (context, cognitoState) {
                switch (cognitoState) {
                  case CognitoRegisterFailureState(failure: final failure):
                    switch (failure) {
                      case RegisterFailure(type: final type):
                        StyledBanner.show(message: type.message, error: true);
                        if (type == RegisterFailureType.userExists) {
                          context.registerBloc.pageController.jumpToPage(1);
                        }
                      case ValidationFailure(message: final message) ||
                            RegisterUnknownResponse(message: final message):
                        StyledBanner.show(message: message, error: true);
                    }
                  case CognitoLoginFailureState(failure: final failure):
                    switch (failure) {
                      case LoginFailure(message: final message) ||
                            LoginChangePasswordRequired(
                              message: final message
                            ) ||
                            LoginUnknownResponse(message: final message):
                        StyledBanner.show(message: message, error: true);
                      case LoginConfirmationRequired(password: final password):
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (context) => ConfirmEmailScreen(
                              password: password,
                            ),
                          ),
                        );
                    }
                  default:
                }
              },
              builder: (context, cognitoState) => Form(
                key: context.registerBloc.formKey,
                autovalidateMode: screenState.autovalidateMode,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: switch (cognitoState) {
                    CognitoRegisterLoadingState() ||
                    CognitoLoginLoadingState() =>
                      const RegisterLoadingPage(),
                    _ => PageView(
                        controller: context.registerBloc.pageController,
                        children: const [
                          RegisterNamePage(),
                          RegisterAccountInfoPage(),
                          RegisterInviterEmailPage(),
                        ],
                      ),
                  },
                ),
              ),
            ),
          ),
        ),
      );
}
