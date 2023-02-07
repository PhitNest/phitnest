part of registration_page;

extension _OnRetryLoadGyms on _RegistrationBloc {
  void onRetryLoadGyms(
    _RetryLoadGymsEvent event,
    Emitter<_RegistrationState> emit,
  ) =>
      emit(
        _InitialState(
          firstNameConfirmed: state.firstNameConfirmed,
          currentPage: state.currentPage,
          autovalidateMode: state.autovalidateMode,
          takenEmails: state.takenEmails,
          loadGymsOp: CancelableOperation.fromFuture(
            UseCases.getNearbyGyms(),
          )..then(
              (either) => either.fold(
                (success) =>
                    add(_GymsLoadedEvent(success.value1, success.value2)),
                (failure) => add(_GymsLoadingErrorEvent(failure)),
              ),
            ),
        ),
      );
}
