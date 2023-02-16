part of registration_page;

extension _OnRegisterError on _RegistrationBloc {
  void onRegisterError(
    _RegisterErrorEvent event,
    Emitter<_IRegistrationState> emit,
  ) {
    final state = this.state as _RegisterLoadingState;
    if (event.failure == Failures.usernameExists.instance) {
      emit(
        _IGymSelectedStateState(
          autovalidateMode: AutovalidateMode.always,
          gym: state.gym,
          gyms: state.gyms,
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          takenEmails: {
            ...state.takenEmails,
            emailController.text.trim(),
          },
          location: state.location,
        ),
      );
      pageController.jumpToPage(1);
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          add(const _SubmitPageTwoEvent());
        },
      );
    } else {
      emit(
        _RegisterErrorState(
          autovalidateMode: state.autovalidateMode,
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          gym: state.gym,
          gyms: state.gyms,
          location: state.location,
          takenEmails: state.takenEmails,
          failure: event.failure,
        ),
      );
      pageController.jumpToPage(3);
    }
  }
}
