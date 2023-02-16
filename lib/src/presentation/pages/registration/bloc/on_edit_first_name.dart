part of registration_page;

extension _OnEditFirstName on _RegistrationBloc {
  void onEditFirstName(
    _EditFirstNameEvent event,
    Emitter<_IRegistrationState> emit,
  ) {
    final validation = validateName(firstNameController.text);
    if (state is _SuccessState) {
      final state = this.state as _SuccessState;
      emit(
        _SuccessState(
          firstNameConfirmed: validation == null,
          currentPage: state.currentPage,
          autovalidateMode: state.autovalidateMode,
          takenEmails: state.takenEmails,
          response: state.response,
          password: state.password,
        ),
      );
    } else if (state is _RegisterErrorState) {
      final state = this.state as _RegisterErrorState;
      emit(
        _RegisterErrorState(
          autovalidateMode: state.autovalidateMode,
          firstNameConfirmed: validation == null,
          currentPage: state.currentPage,
          gym: state.gym,
          gyms: state.gyms,
          location: state.location,
          takenEmails: state.takenEmails,
          failure: state.failure,
        ),
      );
    } else if (state is _RegisterLoadingState) {
      final state = this.state as _RegisterLoadingState;
      emit(
        _RegisterLoadingState(
          autovalidateMode: state.autovalidateMode,
          firstNameConfirmed: validation == null,
          currentPage: state.currentPage,
          gym: state.gym,
          gyms: state.gyms,
          location: state.location,
          takenEmails: state.takenEmails,
          registerOp: state.registerOp,
        ),
      );
    } else if (state is _IGymSelectedStateState) {
      final state = this.state as _IGymSelectedStateState;
      emit(
        _IGymSelectedStateState(
          firstNameConfirmed: validation == null,
          location: state.location,
          gyms: state.gyms,
          currentPage: state.currentPage,
          autovalidateMode: state.autovalidateMode,
          gym: state.gym,
          takenEmails: state.takenEmails,
        ),
      );
    } else if (state is _InitialState) {
      final state = this.state as _InitialState;
      emit(
        _InitialState(
          firstNameConfirmed: validation == null,
          currentPage: state.currentPage,
          autovalidateMode: state.autovalidateMode,
          loadGymsOp: state.loadGymsOp,
          takenEmails: state.takenEmails,
        ),
      );
    } else if (state is _IGymsLoadedStateState) {
      final state = this.state as _IGymsLoadedStateState;
      emit(
        _IGymsLoadedStateState(
          firstNameConfirmed: validation == null,
          currentPage: state.currentPage,
          autovalidateMode: state.autovalidateMode,
          gyms: state.gyms,
          takenEmails: state.takenEmails,
          location: state.location,
        ),
      );
    } else if (state is _GymsLoadingErrorState) {
      final state = this.state as _GymsLoadingErrorState;
      emit(
        _GymsLoadingErrorState(
          takenEmails: state.takenEmails,
          firstNameConfirmed: validation == null,
          currentPage: state.currentPage,
          autovalidateMode: state.autovalidateMode,
          failure: state.failure,
        ),
      );
    } else {
      throw Exception('Invalid state: $state');
    }
  }
}
