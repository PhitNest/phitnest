import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/theme.dart';
import '../../../../data/data_sources/backend/backend.dart';
import '../../pages.dart';
import '../bloc/forgot_password_bloc.dart';
import '../event/submit.dart';
import '../state/forgot_password_state.dart';
import 'widgets/initial.dart';
import 'widgets/loading.dart';

ForgotPasswordBloc _bloc(BuildContext context) => context.read();

void _onSubmit(BuildContext context) => _bloc(context).add(SubmitEvent());

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) async {
          if (state is SuccessState) {
            final result = await Navigator.of(context).push<LoginResponse>(
              CupertinoPageRoute(
                builder: (context) => ForgotPasswordSubmitPage(
                  email: state.emailController.text.trim(),
                  password: state.passwordController.text,
                ),
              ),
            );
            if (result != null) {
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomePage(
                    initialUserData: result.user,
                    initialPassword: state.passwordController.text,
                    initialAccessToken: result.session.accessToken,
                    initialRefreshToken: result.session.refreshToken,
                  ),
                ),
                (_) => false,
              );
            }
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
            final response = await Navigator.of(context).push(
              CupertinoPageRoute<LoginResponse>(
                builder: (context) => ConfirmEmailPage(
                  email: state.emailController.text.trim(),
                  shouldLogin: false,
                  password: null,
                ),
              ),
            );
            if (response != null) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ForgotPasswordSubmitPage(
                    email: state.emailController.text.trim(),
                    password: state.passwordController.text,
                  ),
                ),
              );
            }
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
