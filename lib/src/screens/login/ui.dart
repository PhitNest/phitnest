import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../../common/util.dart';
import '../../widgets/styled_banner.dart';
import '../confirm_email/ui.dart';
import '../home/ui.dart';
import 'bloc/bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider(
          create: (_) => LoginBloc(),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, screenState) {},
            builder: (context, screenState) =>
                BlocConsumer<CognitoBloc, CognitoState>(
              listener: (context, cognitoState) {
                switch (cognitoState) {
                  case CognitoLoggedInState():
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute<void>(
                        builder: (context) => const HomeScreen(),
                      ),
                      (_) => false,
                    );
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
                key: context.loginBloc.formKey,
                autovalidateMode: screenState.autovalidateMode,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: context.loginBloc.emailController,
                    ),
                    TextFormField(
                      controller: context.loginBloc.passwordController,
                    ),
                    switch (cognitoState) {
                      CognitoLoginLoadingState() =>
                        const CircularProgressIndicator(),
                      _ => TextButton(
                          child: const Text('LOGIN'),
                          onPressed: () => context.cognitoBloc.add(
                            CognitoLoginEvent(
                              email: context.loginBloc.emailController.text,
                              password:
                                  context.loginBloc.passwordController.text,
                            ),
                          ),
                        ),
                    },
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
