part of verification_page;

extension on BuildContext {
  _VerificationBloc get bloc => read();
}

class VerificationPage extends StatelessWidget {
  final String headerText;
  final String email;
  final Future<Failure?> Function(String code) confirm;
  final Future<Failure?> Function() resend;
  final String? password;
  final bool shouldLogin;

  void _onCompleted(BuildContext context) => context.bloc.add(
        _SubmitEvent(
          confirmation: (code) => confirm(code).then(
            (failure) async => failure != null
                ? Right(failure)
                : shouldLogin
                    ? (await Repositories.auth.login(
                        email: email,
                        password: password!,
                      )) as Either<LoginResponse?, Failure>
                    : Left(null),
          ),
        ),
      );

  void _onPressedResend(BuildContext context) =>
      context.bloc.add(_ResendEvent(resend));

  const VerificationPage({
    Key? key,
    required this.headerText,
    required this.email,
    required this.confirm,
    required this.resend,
    required this.password,
    this.shouldLogin = true,
  })  : assert(password != null && shouldLogin ||
            password == null && !shouldLogin),
        super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => _VerificationBloc(password != null),
        child: BlocConsumer<_VerificationBloc, _VerificationState>(
          listener: (context, state) async {
            if (state is _SuccessState) {
              Navigator.pop(context, state.response);
            } else if (state is _ProfilePictureUploadState) {
              if ((await Navigator.push<XFile>(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ProfilePicturePage(
                        uploadImage: (photo) =>
                            UseCases.uploadPhotoUnauthorized(
                          email: email,
                          password: password!,
                          photo: photo,
                        ),
                      ),
                    ),
                  )) !=
                  null) {
                _onCompleted(context);
              }
            }
          },
          builder: (context, state) {
            if (state is _ConfirmingState || state is _ResendingState) {
              return _LoadingPage(
                codeController: context.bloc.codeController,
                codeFocusNode: context.bloc.codeFocusNode,
                headerText: headerText,
                email: email,
              );
            } else if (state is _ConfirmErrorState) {
              return _ErrorPage(
                codeController: context.bloc.codeController,
                codeFocusNode: context.bloc.codeFocusNode,
                onCompleted: () => _onCompleted(context),
                onPressedResend: () => _onPressedResend(context),
                headerText: headerText,
                error: state.failure,
                email: email,
              );
            } else if (state is _ResendErrorState) {
              return _ErrorPage(
                codeController: context.bloc.codeController,
                codeFocusNode: context.bloc.codeFocusNode,
                onCompleted: () => _onCompleted(context),
                onPressedResend: () => _onPressedResend(context),
                headerText: headerText,
                error: state.failure,
                email: email,
              );
            } else {
              return _InitialPage(
                codeController: context.bloc.codeController,
                codeFocusNode: context.bloc.codeFocusNode,
                onCompleted: () => _onCompleted(context),
                onPressedResend: () => _onPressedResend(context),
                headerText: headerText,
                email: email,
              );
            }
          },
        ),
      );
}
