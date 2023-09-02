import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../home/home.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

void _handleStateChanged(
  BuildContext context,
  LoaderState<ChangePasswordResponse> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case ChangePasswordSuccess(session: final session):
          context.sessionLoader
              .add(LoaderSetEvent(RefreshSessionSuccess(session)));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const HomePage(),
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
}

final class ChangePasswordPage extends StatelessWidget {
  final UnauthenticatedSession unauthenticatedSession;

  const ChangePasswordPage({
    super.key,
    required this.unauthenticatedSession,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: changePasswordForm(
            unauthenticatedSession,
            (context, controllers, submit) => LoaderConsumer(
              listener: _handleStateChanged,
              builder: (context, loaderState) => Column(
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
                    onFieldSubmitted: (_) => submit(
                        controllers.passwordController.text, loaderState),
                  ),
                  switch (loaderState) {
                    LoaderLoadingState() => const CircularProgressIndicator(),
                    LoaderLoadedState() || LoaderInitialState() => SubmitButton(
                        onSubmit: () => submit(
                            controllers.passwordController.text, loaderState),
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
        ),
      );
}
