part of registration_page;

extension on _RegistrationBloc {
  void onSuccess(
    _SuccessEvent event,
    Emitter<_RegistrationState> emit,
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
