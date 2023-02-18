part of forgot_password_page;

extension _Bloc on BuildContext {
  _ForgotPasswordBloc get bloc => read();

  Future<void> goToSubmitPage() {
    final email = bloc.emailController.text.trim();
    final password = bloc.passwordController.text;
    return Navigator.push<LoginResponse>(
      this,
      CupertinoPageRoute(
        builder: (context) => ForgotPasswordSubmitPage(
          email: email,
          password: password,
        ),
      ),
    ).then(
      (submitResult) {
        if (submitResult != null) {
          return Navigator.pushAndRemoveUntil(
            this,
            CupertinoPageRoute(
              builder: (context) => HomePage(),
            ),
            (_) => false,
          );
        }
      },
    );
  }

  void onPressedSubmit() => bloc.add(const _SubmitEvent());
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ForgotPasswordBloc(),
      child: BlocConsumer<_ForgotPasswordBloc, _IForgotPasswordState>(
        listener: (context, state) async {
          if (state is _SuccessState) {
            return context.goToSubmitPage();
          } else if (state is _ErrorState) {
            StyledErrorBanner.show(
              context,
              state.failure,
              state.dismiss,
            );
          } else if (state is _ConfirmingEmailState) {
            final String email = context.bloc.emailController.text.trim();
            final confirmEmailResponse = await Navigator.push(
              context,
              CupertinoPageRoute<LoginResponse>(
                builder: (context) => ConfirmEmailPage(
                  email: email,
                  shouldLogin: false,
                  password: Cache.password,
                ),
              ),
            );
            if (confirmEmailResponse != null) {
              return context.goToSubmitPage();
            }
          }
        },
        builder: (context, state) {
          if (state is _LoadingState) {
            return _LoadingPage(
              emailController: context.bloc.emailController,
              passwordController: context.bloc.passwordController,
              confirmPassController: context.bloc.confirmPassController,
              autovalidateMode: state.autovalidateMode,
              formKey: context.bloc.formKey,
            );
          } else {
            return _InitialPage(
              emailController: context.bloc.emailController,
              passwordController: context.bloc.passwordController,
              confirmPassController: context.bloc.confirmPassController,
              autovalidateMode: state.autovalidateMode,
              formKey: context.bloc.formKey,
              onSubmit: context.onPressedSubmit,
            );
          }
        },
      ),
    );
  }
}
