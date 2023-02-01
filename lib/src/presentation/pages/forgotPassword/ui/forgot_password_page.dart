part of forgot_password_page;

extension _Bloc on BuildContext {
  _ForgotPasswordBloc get bloc => read();

  Future<void> goToSubmitPage() => Navigator.push<LoginResponse>(
        this,
        CupertinoPageRoute(
          builder: (context) => ForgotPasswordSubmitPage(
            email: context.bloc.emailController.text.trim(),
            password: context.bloc.passwordController.text,
          ),
        ),
      ).then(
        (submitResult) {
          if (submitResult != null) {
            return Navigator.pushAndRemoveUntil(
              this,
              CupertinoPageRoute(
                builder: (context) => HomePage(
                  initialUserData: submitResult.user,
                  initialPassword: context.bloc.passwordController.text,
                  initialAccessToken: submitResult.accessToken,
                  initialRefreshToken: submitResult.refreshToken,
                ),
              ),
              (_) => false,
            );
          }
        },
      );

  void onPressedSubmit() => bloc.add(const _SubmitEvent());
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ForgotPasswordBloc(),
      child: BlocConsumer<_ForgotPasswordBloc, _ForgotPasswordState>(
        listener: (context, state) async {
          if (state is _SuccessState) {
            return context.goToSubmitPage();
          } else if (state is _ErrorState) {
            ScaffoldMessenger.of(context).showMaterialBanner(
              StyledErrorBanner(
                err: state.failure.message,
                context: context,
              ),
            );
          } else if (state is _ConfirmingEmailState) {
            final confirmEmailResponse = await Navigator.of(context).push(
              CupertinoPageRoute<LoginResponse>(
                builder: (context) => ConfirmEmailPage(
                  email: context.bloc.emailController.text.trim(),
                  shouldLogin: false,
                  password: null,
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
