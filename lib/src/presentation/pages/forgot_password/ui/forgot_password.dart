import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../login/ui/login_page.dart';
import '../bloc/forgot_password_bloc.dart';
import '../event/submit.dart';
import '../state/initial.dart';
import '../state/loading.dart';
import '../state/success.dart';
import 'widgets/initial.dart';
import 'widgets/loading.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordBloc>(
      create: (context) => ForgotPasswordBloc(),
      child: BlocConsumer(
        listener: (context, state) {
          if (state is ForgotPasswordSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => LoginPage(),
              ),
              (_) => false,
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
