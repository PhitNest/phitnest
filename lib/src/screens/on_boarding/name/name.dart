import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../account_info/account_info.dart';

part 'bloc/bloc.dart';
part 'bloc/event.dart';
part 'bloc/state.dart';

void _submit(BuildContext context) {
  if (context.onBoardingNameBloc.formKey.currentState!.validate()) {
    Navigator.push(
      context,
      CupertinoPageRoute<void>(
        builder: (context) => OnBoardingAccountInfoScreen(
          firstName: context.onBoardingNameBloc.firstNameController.text,
          lastName: context.onBoardingNameBloc.lastNameController.text,
        ),
      ),
    );
  } else {
    context.onBoardingNameBloc.add(const OnBoardingNameRejectedEvent());
  }
}

class OnBoardingNameScreen extends StatelessWidget {
  const OnBoardingNameScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider(
          create: (context) => OnBoardingNameBloc(),
          child: BlocConsumer<OnBoardingNameBloc, OnBoardingNameState>(
            listener: (context, state) {},
            builder: (context, state) => Form(
              key: context.onBoardingNameBloc.formKey,
              autovalidateMode: state.autovalidateMode,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: context.onBoardingNameBloc.firstNameController,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: context.onBoardingNameBloc.lastNameController,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
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
