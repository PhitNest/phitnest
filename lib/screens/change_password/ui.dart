import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class ChangePasswordScreen extends StatefulWidget {
  final String email;

  const ChangePasswordScreen({
    super.key,
    required this.email,
  }) : super();

  static Future<void> navigate(
    BuildContext context,
    ({String email}) params,
  ) =>
      Navigator.of(context).pushNamed('/changePassword', arguments: params);

  @override
  ChangePasswordScreenStateInternal createState() =>
      ChangePasswordScreenStateInternal();
}

class ChangePasswordScreenStateInternal extends State<ChangePasswordScreen> {
  void onSubmit(BuildContext context) {
    if (context.changePasswordBloc.formKey.currentState!.validate()) {
      context.changePasswordBloc.add(const PasswordFormAcceptedEvent());
      context.authBloc.add(
        AuthChangePasswordEvent(
          email: widget.email,
          newPassword:
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
          child: BlocProvider(
            create: (_) => ChangePasswordBloc(),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, authState) {
                print(authState);
              },
              builder: (context, authState) =>
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
                      switch (screenState.changePasswordButtonState) {
                        ChangePasswordButtonState.enabled => SubmitButton(
                            onSubmit: () => onSubmit(context),
                          ),
                        ChangePasswordButtonState.loading =>
                          const CircularProgressIndicator(),
                      },
                      const SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        onPressed: () => context.authBloc
                            .add(const AuthCancelRequestEvent()),
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

  @override
  void dispose() {
    context.authBloc.add(const AuthCancelRequestEvent());
    super.dispose();
  }
}
