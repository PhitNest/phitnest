import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../../common/util.dart';
import '../../widgets/widgets.dart';
import 'bloc/bloc.dart';

void onSubmit(BuildContext context) {
  if (context.loginBloc.formKey.currentState!.validate()) {
    context.loginBloc.add(const LoginFormAcceptedEvent());
    context.authBloc.add(
      AuthLoginEvent(
        email: context.loginBloc.emailController.text,
        password: context.loginBloc.passwordController.text,
      ),
    );
  } else {
    context.loginBloc.add(const LoginFormRejectedEvent());
  }
}

void cancelLogin(BuildContext context) {
  context.authBloc.add(const AuthCancelRequestEvent());
  context.loginBloc.add(const ResetLoginButtonEvent());
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  }) : super();

  @override
  LoginScreenStateInternal createState() => LoginScreenStateInternal();
}

class LoginScreenStateInternal extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: BlocProvider(
            create: (_) => LoginBloc(),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, authState) {
                print(authState);
              },
              builder: (context, authState) =>
                  BlocConsumer<LoginBloc, LoginState>(
                listener: (context, screenState) {
                  print(screenState);
                },
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
                      switch (screenState.loginButtonState) {
                        LoginButtonState.enabled => const LoginButton(),
                        LoginButtonState.loading =>
                          const CircularProgressIndicator(),
                      },
                      const SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        onPressed: () => cancelLogin(context),
                        child: const Text(
                          'Forgot Password',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    context.authBloc.add(const AuthCancelRequestEvent());
    super.dispose();
  }
}
