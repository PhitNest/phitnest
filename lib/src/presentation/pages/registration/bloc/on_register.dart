part of registration_page;

extension _OnRegister on _RegistrationBloc {
  void onRegister(
    _RegisterEvent event,
    Emitter<_RegistrationState> emit,
  ) {
    final state = this.state as _GymSelected;
    // Validate (we can't use the form key because we aren't currently on these pages)
    if (validateName(firstNameController.text) != null ||
        validateName(lastNameController.text) != null) {
      pageController.jumpToPage(0);
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          add(const _SubmitPageOneEvent());
        },
      );
    } else if (validateEmail(emailController.text) != null ||
        state.takenEmails.contains(emailController.text) ||
        validatePassword(passwordController.text) != null ||
        passwordController.text != confirmPasswordController.text) {
      pageController.jumpToPage(1);
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          add(const _SubmitPageTwoEvent());
        },
      );
    } else {
      emit(
        _RegisterLoadingState(
          autovalidateMode: state.autovalidateMode,
          gym: state.gym,
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          takenEmails: state.takenEmails,
          gyms: state.gyms,
          location: state.location,
          registerOp: CancelableOperation.fromFuture(
            Repositories.auth.register(
              email: emailController.text.trim(),
              password: passwordController.text,
              firstName: firstNameController.text.trim(),
              lastName: lastNameController.text.trim(),
              gymId: state.gym.id,
            ),
          )..then(
              (either) => either.fold(
                (success) => add(_SuccessEvent(success)),
                (failure) => add(_RegisterErrorEvent(failure)),
              ),
            ),
        ),
      );
    }
  }
}
