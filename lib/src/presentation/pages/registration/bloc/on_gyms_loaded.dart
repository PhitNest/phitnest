part of registration_page;

extension on _RegistrationBloc {
  void onGymsLoaded(
    _GymsLoadedEvent event,
    Emitter<_RegistrationState> emit,
  ) =>
      emit(
        _GymsLoadedState(
          firstNameConfirmed: state.firstNameConfirmed,
          gyms: event.gyms,
          location: event.location,
          currentPage: state.currentPage,
          autovalidateMode: state.autovalidateMode,
          takenEmails: state.takenEmails,
        ),
      );
}
