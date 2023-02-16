part of registration_page;

extension _OnGymsLoaded on _RegistrationBloc {
  void onGymsLoaded(
    _IGymsLoadedStateEvent event,
    Emitter<_IRegistrationState> emit,
  ) =>
      emit(
        _IGymsLoadedStateState(
          firstNameConfirmed: state.firstNameConfirmed,
          gyms: event.gyms,
          location: event.location,
          currentPage: state.currentPage,
          autovalidateMode: state.autovalidateMode,
          takenEmails: state.takenEmails,
        ),
      );
}
