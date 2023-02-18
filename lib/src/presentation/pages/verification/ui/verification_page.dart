part of verification_page;

class VerificationPage extends StatelessWidget {
  final String headerText;
  final Future<Failure?> Function(String code) confirm;
  final Future<Failure?> Function() resend;
  final String email;
  final String? password;
  final bool shouldLogin;

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
          } else if (state is _ProfilePictureUploadState) {
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
          if (state is _ConfirmingState ||
              state is _ResendingState ||
              state is _LoginLoadingState) {
            return _LoadingPage(
              codeController: context.bloc.codeController,
              headerText: headerText,
              email: email,
            );
          } else {
            return _InitialPage(
              codeController: context.bloc.codeController,
              onSubmit: () => context.bloc.add(const _SubmitEvent()),
              onPressedResend: () =>
                  () => context.bloc.add(const _ResendEvent()),
              headerText: headerText,
              email: email,
            );
          }
        },
      );
}
