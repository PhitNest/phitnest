part of verification_page;

class VerificationPage extends StatelessWidget {
  final String headerText;
  final Future<Failure?> Function(String code) confirm;
  final Future<Failure?> Function() resend;
  final String email;
  final String? password;
  final bool shouldLogin;

  /// **POP RESULT: [LoginResponse] if [shouldLogin] is true, otherwise null.**
  ///
  /// This page is used to verify the user's email address.
  ///
  /// Users may need to visit this page for either forgot password or confirm email.
  /// The [confirm] and [resend] methods should be provided to this constructor accordingly
  /// to the use case.
  ///
  /// The [shouldLogin] flag controls whether or not this page will attempt to make a login
  /// request after the user has successfully verified their email address. If [shouldLogin]
  /// is true, then the [password] must be provided.
  const VerificationPage({
    Key? key,
    required this.headerText,
    required this.email,
    required this.confirm,
    required this.resend,
    required this.password,
    this.shouldLogin = true,
  })  : assert(password != null && shouldLogin || !shouldLogin),
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocWidget<_VerificationBloc, _IVerificationState>(
        create: (context) => _VerificationBloc(
          email: email,
          confirm: confirm,
          resend: resend,
          password: password,
          shouldLogin: shouldLogin,
        ),
        listener: (context, state) async {
          if (state is _SuccessState) {
            Navigator.pop(context, state.response);
          }
          if (state is _ProfilePictureUploadState) {
            if ((await Navigator.push<XFile>(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ProfilePicturePage(
                      uploadImage: (photo) => UseCases.uploadPhotoUnauthorized(
                        email: email,
                        photo: photo,
                      ),
                    ),
                  ),
                )) !=
                null) {
              context.bloc.add(const _SubmitEvent());
            }
          }
        },
        builder: (context, state) {
          final loading = state is _ConfirmingState ||
              state is _ResendingState ||
              state is _LoginLoadingState;
          return StyledScaffold(
            body: Column(
              children: [
                const StyledBackButton(),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: SizedBox(
                      height: 1.sh - MediaQuery.of(context).padding.top - 46.h,
                      child: Column(
                        children: [
                          30.verticalSpace,
                          Text(
                            headerText,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineLarge,
                          ),
                          40.verticalSpace,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              "Check $email for a verification code from us and enter it below",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                          30.verticalSpace,
                          StyledVerificationField(
                            controller: context.bloc.codeController,
                            onCompleted: loading
                                ? (_) {}
                                : (_) => context.bloc.add(const _SubmitEvent()),
                          ),
                          loading
                              ? Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: const CircularProgressIndicator(),
                                )
                              : Expanded(
                                  child: Column(
                                    children: [
                                      20.verticalSpace,
                                      StyledButton(
                                        text: 'SUBMIT',
                                        onPressed: () => context.bloc
                                            .add(const _SubmitEvent()),
                                      ),
                                      Spacer(),
                                      StyledUnderlinedTextButton(
                                        onPressed: () => () => context.bloc
                                            .add(const _ResendEvent()),
                                        text: 'RESEND CODE',
                                      ),
                                      37.verticalSpace,
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}
