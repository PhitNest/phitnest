import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

part 'bloc/bloc.dart';
part 'bloc/event.dart';
part 'bloc/state.dart';

void _submit(OnBoardingAccountInfoBloc bloc) {
  if (bloc.formKey.currentState!.validate()) {
  } else {
    bloc.add(const OnBoardingAccountInfoRejectedEvent());
  }
}

class OnBoardingAccountInfoScreen extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String? initialEmail;
  final String? initialPassword;

  const OnBoardingAccountInfoScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    this.initialEmail,
    this.initialPassword,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider(
          create: (context) => OnBoardingAccountInfoBloc(
            initialEmail: initialEmail,
            initialPassword: initialPassword,
          ),
          child: BlocConsumer<OnBoardingAccountInfoBloc,
              OnBoardingAccountInfoState>(
            listener: (context, state) {},
            builder: (context, state) => Form(
              key: context.onBoardingAccountInfoBloc.formKey,
              autovalidateMode: state.autovalidateMode,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller:
                        context.onBoardingAccountInfoBloc.emailController,
                    validator: EmailValidator.validateEmail,
                  ),
                  TextFormField(
                    controller:
                        context.onBoardingAccountInfoBloc.passwordController,
                    validator: validatePassword,
                  ),
                  TextFormField(
                    controller: context
                        .onBoardingAccountInfoBloc.confirmPasswordController,
                    validator: (value) => value ==
                            context.onBoardingAccountInfoBloc.passwordController
                                .text
                        ? 'Passwords do not match'
                        : null,
                  ),
                  TextButton(
                    onPressed: () => _submit(context.onBoardingAccountInfoBloc),
                    child: const Text('NEXT'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
