import '../screen_state.dart';

abstract class ConfirmPhotoState extends ScreenState {
  const ConfirmPhotoState() : super();
}

class LoadingState extends ConfirmPhotoState {
  const LoadingState() : super();
}

class ErrorState extends ConfirmPhotoState {
  final String message;

  const ErrorState(this.message) : super();

  @override
  List<Object> get props => [message];
}

class InitialState extends ConfirmPhotoState {
  const InitialState() : super();
}

class ConfirmPhotoCubit extends ScreenCubit<ConfirmPhotoState> {
  ConfirmPhotoCubit() : super(const InitialState());

  void transitionToLoading() => setState(const LoadingState());

  void transitionToError(String message) => setState(ErrorState(message));
}
