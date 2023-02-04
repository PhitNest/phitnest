part of registration_page;

extension on _RegistrationBloc {
  void onGymSelected(
    _GymSelectedEvent event,
    Emitter<_RegistrationState> emit,
  ) async {
    if (state is _RegisterLoadingState) {
      final state = this.state as _RegisterLoadingState;
      emit(
        _RegisterLoadingState(
          autovalidateMode: state.autovalidateMode,
          gym: state.gym,
          gyms: state.gyms,
          takenEmails: state.takenEmails,
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          location: state.location,
          registerOp: state.registerOp,
        ),
      );
    } else {
      final state = this.state as _GymsLoaded;
      emit(
        _GymSelectedState(
          firstNameConfirmed: state.firstNameConfirmed,
          gyms: state.gyms,
          takenEmails: state.takenEmails,
          location: state.location,
          gym: event.gym,
          currentPage: state.currentPage,
          autovalidateMode: state.autovalidateMode,
        ),
      );
    }
  }
}
