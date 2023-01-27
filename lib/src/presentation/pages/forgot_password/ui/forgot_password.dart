import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/theme.dart';
import '../../pages.dart';
import '../bloc/forgot_password_bloc.dart';
import '../event/submit.dart';
import '../state/forgot_password_state.dart';
import 'widgets/initial.dart';
import 'widgets/loading.dart';
import 'widgets/verification_page.dart';

ForgotPasswordBloc _bloc(BuildContext context) => context.read();

void _onSubmit(BuildContext context) => _bloc(context).add(SubmitEvent());

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is SuccessState) {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => VerifyEmail(
                  email: state.emailController.text.trim(),
                  password: state.passwordController.text,
                ),
              ),
            );
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                content: Text(
                  state.failure.message.toString(),
                  style: theme.textTheme.bodySmall!.copyWith(color: Colors.red),
                ),
                padding: EdgeInsets.all(10),
                elevation: 8,
                onVisible: () => Future.delayed(Duration(seconds: 3)).then(
                  (_) =>
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                ),
                backgroundColor: Colors.white,
                leading: Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    },
                    child: Text(
                      'Dismiss',
                      style: theme.textTheme.bodySmall,
                    ),
                  )
                ],
              ),
            );
          } else if (state is ConfirmEmailState) {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => ConfirmEmailPage(
                  email: state.emailController.text.trim(),
                  onConfirmed: (context) => Navigator.of(context)
                    ..pop()
                    ..push(
                      CupertinoPageRoute(
                        builder: (context) => VerifyEmail(
                          email: state.emailController.text.trim(),
                          password: state.passwordController.text.trim(),
                        ),
                      ),
                    ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return ForgotPasswordLoadingPage(
              emailController: state.emailController,
              passwordController: state.passwordController,
              confirmPassController: state.confirmPassController,
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              confirmPassFocusNode: state.confirmPassFocusNode,
              autovalidateMode: state.autovalidateMode,
              formKey: state.formKey,
            );
          } else if (state is ErrorState) {
            return ForgotPasswordInitialPage(
              emailController: state.emailController,
              passwordController: state.passwordController,
              confirmPassController: state.confirmPassController,
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              confirmPassFocusNode: state.confirmPassFocusNode,
              autovalidateMode: state.autovalidateMode,
              formKey: state.formKey,
              onSubmit: () => _onSubmit(context),
            );
          } else if (state is InitialState) {
            return ForgotPasswordInitialPage(
              emailController: state.emailController,
              passwordController: state.passwordController,
              confirmPassController: state.confirmPassController,
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              confirmPassFocusNode: state.confirmPassFocusNode,
              autovalidateMode: state.autovalidateMode,
              formKey: state.formKey,
              onSubmit: () => _onSubmit(context),
            );
          } else {
            throw Exception('Invalid state: $state');
          }
        },
      ),
    );
  }
}
