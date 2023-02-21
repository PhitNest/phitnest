part of registration_page;

extension _OnSwipe on _RegistrationBloc {
  void onSwipe(
    _SwipeEvent event,
    Emitter<_IRegistrationState> emit,
  ) {
    if (state is _SuccessState) {
      final state = this.state as _SuccessState;
      emit(
        _SuccessState(
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: event.pageIndex,
          autovalidateMode: state.autovalidateMode,
          takenEmails: state.takenEmails,
          response: state.response,
          password: state.password,
        ),
      );
    } else if (state is _RegisterLoadingState) {
      final state = this.state as _RegisterLoadingState;
      emit(
        _RegisterLoadingState(
          autovalidateMode: state.autovalidateMode,
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: event.pageIndex,
          gym: state.gym,
          gyms: state.gyms,
          location: state.location,
          takenEmails: state.takenEmails,
          registerOp: state.registerOp,
        ),
      );
    } else if (state is _GymSelectedState) {
      final state = this.state as _GymSelectedState;
      emit(
        _GymSelectedState(
          firstNameConfirmed: state.firstNameConfirmed,
          location: state.location,
          gyms: state.gyms,
          currentPage: event.pageIndex,
          autovalidateMode: state.autovalidateMode,
          gym: state.gym,
          takenEmails: state.takenEmails,
        ),
      );
    } else if (state is _InitialState) {
      final state = this.state as _InitialState;
      emit(
        _InitialState(
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: event.pageIndex,
          autovalidateMode: state.autovalidateMode,
          loadGymsOp: state.loadGymsOp,
          takenEmails: state.takenEmails,
        ),
      );
    } else if (state is _IGymsLoadedStateState) {
      final state = this.state as _IGymsLoadedStateState;
      emit(
        _IGymsLoadedStateState(
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: event.pageIndex,
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
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: event.pageIndex,
          autovalidateMode: state.autovalidateMode,
          failure: state.failure,
        ),
      );
    } else {
      throw Exception('Invalid state: $state');
    }
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    firstNameFocusNode.unfocus();
    lastNameFocusNode.unfocus();
    confirmPasswordFocusNode.unfocus();
  }
}
