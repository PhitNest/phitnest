part of registration_page;

extension _OnGymsLoadingError on _RegistrationBloc {
  void onGymsLoadingError(
    _GymsLoadingErrorEvent event,
    Emitter<_IRegistrationState> emit,
  ) =>
      emit(
        _GymsLoadingErrorState(
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          failure: event.failure,
          takenEmails: state.takenEmails,
          autovalidateMode: state.autovalidateMode,
        ),
      );
}
