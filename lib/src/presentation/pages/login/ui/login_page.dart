part of login_page;

class LoginPage extends StatelessWidget {
  /// **POP RESULT: NONE**
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocWidget<_LoginBloc, _ILoginState>(
        create: (context) => _LoginBloc(),
        listener: (context, state) {
          // Replace widget stack with HomePage if login was successful.
          if (state is _SuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => HomePage(),
              ),
              (_) => false,
            );
          }
          // Push ConfirmEmailPage if login request results in userNotConfirmed.
          if (state is _ConfirmingEmailState) {
            Navigator.push<LoginResponse>(
              context,
              CupertinoPageRoute(
                builder: (context) => ConfirmEmailPage(
                  email: state.email,
                  password: state.password,
                ),
              ),
            )
                // Navigate to HomePage if login request was successful.
                .then(
              (response) {
                if (response != null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    (_) => false,
                  );
                }
              },
            );
          }
        },
        builder: (context, state) {
          return StyledScaffold(
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: SizedBox(
                height: 1.sh,
                width: double.infinity,
                child: Column(
                  children: [
                    80.verticalSpace,
                    Image.asset(
                      Assets.logo.path,
                      width: 61.59.w,
                    ),
                    25.verticalSpace,
                    Text(
                      'PhitNest is Better Together',
                      style: theme.textTheme.headlineMedium,
                    ),
                    40.verticalSpace,
                    SizedBox(
                      width: 291.w,
                      child: Form(
                        key: context.bloc.formKey,
                        autovalidateMode: state.autovalidateMode,
                        child: Column(
                          children: [
                            StyledUnderlinedTextField(
                              controller: context.bloc.emailController,
                              hint: 'Email',
                              errorMaxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  validateEmail(value) ??
                                  // Check if invalidCredentials contains the entered credentials
                                  (state.invalidCredentials.any((credentials) =>
                                          credentials.value1 == value &&
                                          credentials.value2 ==
                                              context
                                                  .bloc.passwordController.text)
                                      ? 'Invalid email/password'
                                      : null),
                            ),
                            StyledPasswordField(
                              controller: context.bloc.passwordController,
                              hint: 'Password',
                              textInputAction: TextInputAction.done,
                              validator: (value) => validatePassword(value),
                              onFieldSubmitted: (_) =>
                                  context.bloc.add(const _SubmitEvent()),
                            ),
                          ],
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    state is _LoadingState
                        ? const CircularProgressIndicator()
                        : StyledButton(
                            text: 'SIGN IN',
                            onPressed: () =>
                                context.bloc.add(const _SubmitEvent()),
                          ),
                    Spacer(),
                    StyledUnderlinedTextButton(
                      text: 'FORGOT PASSWORD?',
                      onPressed: () {
                        context.bloc.add(const _CancelEvent());
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                    ),
                    StyledUnderlinedTextButton(
                      text: 'REGISTER',
                      onPressed: () {
                        context.bloc.add(const _CancelEvent());
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const RegistrationPage(),
                          ),
                        );
                      },
                    ),
                    48.verticalSpace,
                  ],
                ),
              ),
            ),
          );
        },
      );
}
