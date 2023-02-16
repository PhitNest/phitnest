part of verification_page;

class _VerificationBloc extends Bloc<_IVerificationEvent, _IVerificationState> {
  final codeController = TextEditingController();
  final codeFocusNode = FocusNode();

  _VerificationBloc() : super(_InitialState()) {
    on<_SubmitEvent>(onSubmit);
    on<_SuccessEvent>(onSuccess);
    on<_ConfirmErrorEvent>(onConfirmError);
    on<_ResendEvent>(onResend);
    on<_ResendErrorEvent>(onResendError);
    on<_ResetEvent>(onReset);
    on<_ProfilePictureErrorEvent>(onProfilePictureError);
  }

  @override
  Future<void> close() async {
    if (state is _ConfirmingState) {
      final loadingState = state as _ConfirmingState;
      await loadingState.operation.cancel();
    }
    codeController.dispose();
    return super.close();
  }
}
