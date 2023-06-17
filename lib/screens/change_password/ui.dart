import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phitnest_core/core.dart';

import '../../common/util.dart';
import '../../widgets/widgets.dart';
import 'bloc/bloc.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitButton({
    super.key,
    required this.onSubmit,
  }) : super();

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: onSubmit,
        color: Colors.black,
        textColor: Colors.white,
        child: const Text(
          'Submit',
        ),
      );
}

class ChangePasswordScreen extends StatelessWidget {
  final String email;

  const ChangePasswordScreen({
    super.key,
    required this.email,
  }) : super();

  void onSubmit(BuildContext context) {
    if (context.changePasswordBloc.formKey.currentState!.validate()) {
      context.cognitoBloc.add(
        CognitoChangePasswordEvent(
          newPassword:
              context.changePasswordBloc.confirmPasswordController.text,
          email: email,
        ),
      );
    } else {
      context.changePasswordBloc.add(const PasswordFormRejectedEvent());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: BlocProvider(
            create: (_) => ChangePasswordBloc(),
            child: BlocConsumer<CognitoBloc, CognitoState>(
              listener: (context, cognitoState) {
                switch (cognitoState) {
                  case CognitoChangePasswordFailureState(
                      failure: final failure
                    ):
                    context.changePasswordBloc
                        .add(const PasswordFormRejectedEvent());
                    StyledBanner.show(
                      message: failure.message,
                      error: true,
                    );
                  case CognitoLoggedInState():
                    context.goNamed('home');
                  default:
                }
              },
              builder: (context, cognitoState) =>
                  BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                listener: (context, screenState) {},
                builder: (context, screenState) => Form(
                  key: context.changePasswordBloc.formKey,
                  autovalidateMode: screenState.autovalidateMode,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Change Password',
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      StyledPasswordField(
                        hint: 'Password',
                        controller:
                            context.changePasswordBloc.passwordController,
                        textInputAction: TextInputAction.next,
                        validator: validatePassword,
                      ),
                      StyledPasswordField(
                        hint: 'Confirm Password',
                        controller: context
                            .changePasswordBloc.confirmPasswordController,
                        textInputAction: TextInputAction.done,
                        validator: (val) =>
                            validatePassword(val) ??
                            (context.changePasswordBloc.passwordController
                                        .text ==
                                    val
                                ? null
                                : 'Passwords do not match'),
                        onFieldSubmitted: (_) => onSubmit(context),
                      ),
                      switch (cognitoState) {
                        CognitoChangePasswordLoadingState() =>
                          const CircularProgressIndicator(),
                        _ => SubmitButton(
                            onSubmit: () => onSubmit(context),
                          ),
                      },
                      const SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        onPressed: () {
                          context.cognitoBloc
                              .add(const CognitoCancelRequestEvent());
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Back',
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
}
