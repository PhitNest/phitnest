import '../screen_state.dart';

abstract class ConfirmEmailState extends ScreenState {
  const ConfirmEmailState() : super();
}

class InitialState extends ConfirmEmailState {
  const InitialState() : super();
}

class LoadingState extends ConfirmEmailState {
  const LoadingState() : super();
}

class ErrorState extends ConfirmEmailState {
  final String message;

  const ErrorState(this.message) : super();
}

class ConfirmEmailCubit extends ScreenCubit<ConfirmEmailState> {
  ConfirmEmailCubit() : super(const InitialState());

  void transitionToLoading() => setState(const LoadingState());

  void transitionToError(String message) => setState(ErrorState(message));

  void transitionToInitial() => setState(const InitialState());
}
