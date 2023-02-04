part of registration_page;

extension on _RegistrationBloc {
  void onSubmitPageOne(
    _SubmitPageOneEvent event,
    Emitter<_RegistrationState> emit,
  ) {
    if (pageOneFormKey.currentState!.validate()) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      if (state is _SuccessState) {
        final state = this.state as _SuccessState;
        emit(
          _SuccessState(
            firstNameConfirmed: state.firstNameConfirmed,
            currentPage: state.currentPage,
            autovalidateMode: AutovalidateMode.always,
            takenEmails: state.takenEmails,
            response: state.response,
            password: state.password,
          ),
        );
      } else if (state is _RegisterErrorState) {
        final state = this.state as _RegisterErrorState;
        emit(
          _RegisterErrorState(
            autovalidateMode: AutovalidateMode.always,
            firstNameConfirmed: state.firstNameConfirmed,
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
            autovalidateMode: AutovalidateMode.always,
            firstNameConfirmed: state.firstNameConfirmed,
            currentPage: state.currentPage,
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
            currentPage: state.currentPage,
            autovalidateMode: AutovalidateMode.always,
            gym: state.gym,
            takenEmails: state.takenEmails,
          ),
        );
      } else if (state is _InitialState) {
        final state = this.state as _InitialState;
        emit(
          _InitialState(
            firstNameConfirmed: state.firstNameConfirmed,
            currentPage: state.currentPage,
            autovalidateMode: AutovalidateMode.always,
            loadGymsOp: state.loadGymsOp,
            takenEmails: state.takenEmails,
          ),
        );
      } else if (state is _GymsLoadedState) {
        final state = this.state as _GymsLoadedState;
        emit(
          _GymsLoadedState(
            firstNameConfirmed: state.firstNameConfirmed,
            currentPage: state.currentPage,
            autovalidateMode: AutovalidateMode.always,
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
            currentPage: state.currentPage,
            autovalidateMode: AutovalidateMode.always,
            failure: state.failure,
          ),
        );
      } else {
        throw Exception('Invalid state: $state');
      }
    }
  }
}
