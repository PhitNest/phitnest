import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import 'home_screen.dart';

final class ChangePasswordControllers extends FormControllers {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}

final class SubmitButton extends StatelessWidget {
  final void Function() onSubmit;

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

final class ChangePasswordScreen extends StatelessWidget {
  final UnauthenticatedSession unauthenticatedSession;

  const ChangePasswordScreen({
    super.key,
    required this.unauthenticatedSession,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: FormProvider<ChangePasswordControllers, String,
              ChangePasswordResponse>(
            createControllers: (_) => ChangePasswordControllers(),
            createLoader: (_) => LoaderBloc(
              load: (newPassword) => changePassword(
                unauthenticatedSession: unauthenticatedSession,
                newPassword: newPassword,
              ),
            ),
            listener: (context, controllers, state, _) {
              switch (state) {
                case LoaderLoadedState(data: final response):
                  switch (response) {
                    case ChangePasswordSuccess(session: final session):
                      context.sessionLoader
                          .add(LoaderSetEvent(RefreshSessionSuccess(session)));
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) =>
                              HomeScreen(initialSession: session),
                        ),
                        (_) => false,
                      );
                    case ChangePasswordFailureResponse(message: final message):
                      StyledBanner.show(
                        message: message,
                        error: true,
                      );
                  }
                default:
              }
            },
            builder: (context, controllers, state, submit) => Column(
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
                  controller: controllers.passwordController,
                  textInputAction: TextInputAction.next,
                  validator: validatePassword,
                ),
                StyledPasswordField(
                  hint: 'Confirm Password',
                  controller: controllers.confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  validator: (val) =>
                      validatePassword(val) ??
                      (controllers.passwordController.text == val
                          ? null
                          : 'Passwords do not match'),
                  onFieldSubmitted: (_) =>
                      submit(controllers.passwordController.text),
                ),
                switch (state) {
                  LoaderLoadingState() => const CircularProgressIndicator(),
                  LoaderLoadedState() || LoaderInitialState() => SubmitButton(
                      onSubmit: () =>
                          submit(controllers.passwordController.text),
                    ),
                },
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Back',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
