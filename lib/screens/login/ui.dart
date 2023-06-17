import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phitnest_core/core.dart';

import '../../common/util.dart';
import '../../widgets/widgets.dart';
import 'bloc/bloc.dart';

void onSubmit(BuildContext context) {
  if (context.loginBloc.formKey.currentState!.validate()) {
    context.cognitoBloc.add(
      CognitoLoginEvent(
        email: context.loginBloc.emailController.text,
        password: context.loginBloc.passwordController.text,
      ),
    );
  } else {
    context.loginBloc.add(const LoginRejectedEvent());
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: () => onSubmit(context),
        color: Colors.black,
        textColor: Colors.white,
        child: const Text(
          'Login',
        ),
      );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: BlocProvider(
            create: (_) => LoginBloc(),
            child: BlocConsumer<CognitoBloc, CognitoState>(
              listener: (context, cognitoState) {
                switch (cognitoState) {
                  case CognitoLoginFailureState(failure: final failure):
                    context.loginBloc.add(const LoginRejectedEvent());
                    switch (failure) {
                      case LoginChangePasswordRequired():
                        context.goNamed('changePassword');
                      case LoginFailureResponse():
                        StyledBanner.show(
                          message: failure.message,
                          error: true,
                        );
                    }
                  case CognitoLoggedInState():
                    context.goNamed('home');
                  default:
                }
              },
              builder: (context, cognitoState) =>
                  BlocConsumer<LoginBloc, LoginState>(
                listener: (context, screenState) {},
                builder: (context, screenState) => Form(
                  key: context.loginBloc.formKey,
                  autovalidateMode: screenState.autovalidateMode,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PhitNest Admin Login',
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      StyledUnderlinedTextField(
                        hint: 'Email',
                        controller: context.loginBloc.emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: EmailValidator.validateEmail,
                      ),
                      StyledPasswordField(
                        hint: 'Password',
                        controller: context.loginBloc.passwordController,
                        textInputAction: TextInputAction.done,
                        validator: validatePassword,
                        onFieldSubmitted: (_) => onSubmit(context),
                      ),
                      switch (cognitoState) {
                        CognitoLoginLoadingState() =>
                          const CircularProgressIndicator(),
                        _ => const LoginButton(),
                      },
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
