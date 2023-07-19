import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

typedef ChangePasswordFormBloc = FormBloc<ChangePasswordControllers>;
typedef ChangePasswordFormConsumer = FormConsumer<ChangePasswordControllers>;
typedef ChangePasswordLoaderBloc = LoaderBloc<String, ChangePasswordResponse>;
typedef ChangePasswordLoaderConsumer
    = LoaderConsumer<String, ChangePasswordResponse>;

extension on BuildContext {
  ChangePasswordFormBloc get changePasswordFormBloc => BlocProvider.of(this);
  ChangePasswordLoaderBloc get changePasswordLoaderBloc => loader();
}

final class ChangePasswordScreen extends StatelessWidget {
  final UnauthenticatedSession unauthenticatedSession;

  const ChangePasswordScreen({
    super.key,
    required this.unauthenticatedSession,
  }) : super();

  void submit(BuildContext context) => context.changePasswordFormBloc.submit(
        onAccept: () => context.changePasswordLoaderBloc.add(
          LoaderLoadEvent(
            context.changePasswordFormBloc.controllers.confirmPasswordController
                .text,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    ChangePasswordFormBloc(ChangePasswordControllers()),
              ),
              BlocProvider(
                create: (_) => ChangePasswordLoaderBloc(
                  load: (newPassword) => changePassword(
                    unauthenticatedSession: unauthenticatedSession,
                    newPassword: newPassword,
                  ),
                ),
              ),
            ],
            child: ChangePasswordFormConsumer(
              listener: (context, formState) {},
              builder: (context, formState) => Form(
                key: context.changePasswordFormBloc.formKey,
                autovalidateMode: formState.autovalidateMode,
                child: ChangePasswordLoaderConsumer(
                  listener: (context, submitState) {
                    switch (submitState) {
                      case LoaderLoadedState(data: final response):
                        switch (response) {
                          case ChangePasswordSuccess(session: final session):
                            context.sessionLoader.add(
                                LoaderSetEvent(RefreshSessionSuccess(session)));
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => HomeScreen(
                                  apiInfo: session.apiInfo,
                                ),
                              ),
                              (_) => false,
                            );
                          case ChangePasswordFailureResponse(
                              message: final message
                            ):
                            StyledBanner.show(
                              message: message,
                              error: true,
                            );
                        }
                      default:
                    }
                  },
                  builder: (context, submitState) => Column(
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
                        controller: context.changePasswordFormBloc.controllers
                            .passwordController,
                        textInputAction: TextInputAction.next,
                        validator: validatePassword,
                      ),
                      StyledPasswordField(
                        hint: 'Confirm Password',
                        controller: context.changePasswordFormBloc.controllers
                            .confirmPasswordController,
                        textInputAction: TextInputAction.done,
                        validator: (val) =>
                            validatePassword(val) ??
                            (context.changePasswordFormBloc.controllers
                                        .passwordController.text ==
                                    val
                                ? null
                                : 'Passwords do not match'),
                        onFieldSubmitted: (_) => switch (submitState) {
                          LoaderLoadingState() =>
                            const CircularProgressIndicator(),
                          LoaderLoadedState() ||
                          LoaderInitialState() =>
                            submit(context),
                        },
                      ),
                      switch (submitState) {
                        LoaderLoadingState() =>
                          const CircularProgressIndicator(),
                        LoaderLoadedState() ||
                        LoaderInitialState() =>
                          SubmitButton(
                            onSubmit: () => submit(context),
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
          ),
        ),
      );
}
