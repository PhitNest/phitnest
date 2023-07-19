import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_core/core.dart';

import 'home_screen.dart';

final class PasswordFormRejectedEvent extends Equatable {
  const PasswordFormRejectedEvent() : super();

  @override
  List<Object?> get props => [];
}

final class ChangePasswordState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const ChangePasswordState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object?> get props => [autovalidateMode];
}

final class ChangePasswordBloc
    extends Bloc<PasswordFormRejectedEvent, ChangePasswordState> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ChangePasswordBloc()
      : super(
          const ChangePasswordState(
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<PasswordFormRejectedEvent>(
      (event, emit) {
        emit(
          switch (state) {
            ChangePasswordState() => const ChangePasswordState(
                autovalidateMode: AutovalidateMode.always,
              ),
          },
        );
      },
    );
  }

  @override
  Future<void> close() async {
    passwordController.dispose();
    confirmPasswordController.dispose();
    await super.close();
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

typedef ChangePasswordLoaderBloc = LoaderBloc<String, ChangePasswordResponse>;
typedef ChangePasswordLoaderConsumer
    = LoaderConsumer<String, ChangePasswordResponse>;

extension GetChangePasswordBlocs on BuildContext {
  ChangePasswordBloc get changePasswordBloc => BlocProvider.of(this);
  ChangePasswordLoaderBloc get changePasswordLoaderBloc => loader();
}

final class ChangePasswordScreen extends StatelessWidget {
  final ChangePasswordUser user;
  final ApiInfo apiInfo;

  const ChangePasswordScreen({
    super.key,
    required this.user,
    required this.apiInfo,
  }) : super();

  void submit(BuildContext context) {
    if (context.changePasswordBloc.formKey.currentState!.validate()) {
      context.changePasswordLoaderBloc.add(
        LoaderLoadEvent(
          context.changePasswordBloc.confirmPasswordController.text,
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
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => ChangePasswordBloc(),
              ),
              BlocProvider(
                create: (_) => LoaderBloc<String, ChangePasswordResponse>(
                  load: (newPassword) => changePassword(
                    user: user,
                    newPassword: newPassword,
                    apiInfo: apiInfo,
                  ),
                ),
              ),
            ],
            child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
              listener: (context, formState) {},
              builder: (context, formState) => Form(
                key: context.changePasswordBloc.formKey,
                autovalidateMode: formState.autovalidateMode,
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
                      controller: context.changePasswordBloc.passwordController,
                      textInputAction: TextInputAction.next,
                      validator: validatePassword,
                    ),
                    StyledPasswordField(
                      hint: 'Confirm Password',
                      controller:
                          context.changePasswordBloc.confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      validator: (val) =>
                          validatePassword(val) ??
                          (context.changePasswordBloc.passwordController.text ==
                                  val
                              ? null
                              : 'Passwords do not match'),
                      onFieldSubmitted: (_) => submit(context),
                    ),
                    ChangePasswordLoaderConsumer(
                      listener: (context, submitState) {
                        switch (submitState) {
                          case LoaderLoadedState(data: final response):
                            switch (response) {
                              case ChangePasswordSuccess(
                                  session: final session
                                ):
                                context.sessionLoader.add(LoaderSetEvent(
                                    RefreshSessionSuccess(session)));
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) => HomeScreen(
                                      apiInfo: apiInfo,
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
                      builder: (context, submitState) => switch (submitState) {
                        LoaderLoadingState() =>
                          const CircularProgressIndicator(),
                        LoaderLoadedState() ||
                        LoaderInitialState() =>
                          SubmitButton(
                            onSubmit: () => submit(context),
                          ),
                      },
                    ),
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
      );
}
