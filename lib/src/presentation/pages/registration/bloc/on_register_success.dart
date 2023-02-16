part of registration_page;

extension _OnSuccess on _RegistrationBloc {
  void onSuccess(
    _SuccessEvent event,
    Emitter<_IRegistrationState> emit,
  ) =>
      emit(
        _SuccessState(
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          autovalidateMode: state.autovalidateMode,
          takenEmails: state.takenEmails,
          response: event.response,
          password: passwordController.text,
        ),
      );
}
