import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/theme.dart';
import '../bloc/forgot_password_bloc.dart';
import '../event/error.dart';
import '../event/submit.dart';
import '../state/error.dart';
import '../state/initial.dart';
import '../state/loading.dart';
import '../state/success.dart';
import 'widgets/initial.dart';
import 'widgets/loading.dart';
import 'widgets/verification_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccessState) {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => VerifyEmail(
                  email: state.email,
                  password: state.password,
                ),
              ),
            );
          } else if (state is ForgotPasswordErrorState) {
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
            context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordErrorEvent(
                      failure: state.failure,
                      emailController: state.emailController,
                      passwordController: state.passwordController,
                      formKey: state.formKey,
                      autoValidateMode: state.autoValidateMode,
                      confirmPassFocusNode: state.confirmPassFocusNode,
                      passwordFocusNode: state.passwordFocusNode,
                      emailFocusNode: state.emailFocusNode,
                      confirmPassController: state.confirmPassController),
                );
          }
        },
        builder: (context, state) {
          if (state is ForgotPasswordLoadingState) {
            return ForgotPasswordLoadingPage(
              emailController: state.emailController,
              passwordController: state.passwordController,
              confirmPassController: state.confirmPassController,
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              confirmPassFocusNode: state.confirmPassFocusNode,
              autovalidateMode: state.autoValidateMode,
              formKey: state.formKey,
              onSubmit: () => context
                  .read<ForgotPasswordBloc>()
                  .add(ForgotPasswordOnSubmitEvent()),
            );
          } else if (state is ForgotPasswordInitialState) {
            return ForgotPasswordInitialPage(
              emailController: state.emailController,
              passwordController: state.passwordController,
              confirmPassController: state.confirmPassController,
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              confirmPassFocusNode: state.confirmPassFocusNode,
              autovalidateMode: state.autoValidateMode,
              formKey: state.formKey,
              onSubmit: () => context
                  .read<ForgotPasswordBloc>()
                  .add(ForgotPasswordOnSubmitEvent()),
            );
          } else if (state is ForgotPasswordErrorState) {
            return ForgotPasswordInitialPage(
              emailController: state.emailController,
              passwordController: state.passwordController,
              confirmPassController: state.confirmPassController,
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              confirmPassFocusNode: state.confirmPassFocusNode,
              autovalidateMode: state.autoValidateMode,
              formKey: state.formKey,
              onSubmit: () => context
                  .read<ForgotPasswordBloc>()
                  .add(ForgotPasswordOnSubmitEvent()),
            );
          } else {
            throw Exception('Invalid state: $state');
          }
        },
      ),
    );
  }
}
