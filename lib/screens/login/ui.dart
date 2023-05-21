import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import '../../widgets/widgets.dart';
import 'bloc/bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, authState) {},
            builder: (context, authState) {
              LoginBloc bloc() => BlocProvider.of<LoginBloc>(context);

              void submit() => bloc().add(const SubmitLoginFormEvent());

              final loginButton = MaterialButton(
                onPressed: submit,
                color: Colors.black,
                textColor: Colors.white,
                child: const Text(
                  'Login',
                ),
              );

              return BlocProvider<LoginBloc>(
                create: (_) => LoginBloc(),
                child: BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, screenState) {},
                  builder: (context, screenState) => Form(
                    key: bloc().formKey,
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
                          controller: bloc().emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (email) =>
                              EmailValidator.validateEmail(email)
                                  ? null
                                  : 'Invalid email',
                        ),
                        StyledPasswordField(
                          hint: 'Password',
                          controller: bloc().passwordController,
                          textInputAction: TextInputAction.done,
                          validator: (password) => validatePassword(password),
                          onFieldSubmitted: (_) => submit(),
                        ),
                        loginButton,
                        const SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: submit,
                          child: const Text(
                            'Forgot Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}
