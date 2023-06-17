import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

part 'bloc/bloc.dart';
part 'bloc/event.dart';
part 'bloc/state.dart';

void _submit(BuildContext context) {
  if (context.onBoardingInviterBloc.formKey.currentState!.validate()) {
  } else {
    context.onBoardingInviterBloc.add(const OnBoardingInviterRejectedEvent());
  }
}

class OnBoardingInviterScreen extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? initialInviter;

  const OnBoardingInviterScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.initialInviter,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider(
          create: (context) => OnBoardingInviterBloc(
            initialInviter: initialInviter,
          ),
          child: BlocConsumer<OnBoardingInviterBloc, OnBoardingInviterState>(
            listener: (context, state) {},
            builder: (context, state) => Form(
              key: context.onBoardingInviterBloc.formKey,
              autovalidateMode: state.autovalidateMode,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: context.onBoardingInviterBloc.inviterController,
                    validator: EmailValidator.validateEmail,
                  ),
                  TextButton(
                    onPressed: () => _submit(context),
                    child: const Text('NEXT'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
