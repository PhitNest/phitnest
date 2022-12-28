import '../screen_state.dart';

abstract class OptionsState extends ScreenState {
  const OptionsState() : super();
}

class InitialState extends OptionsState {
  const InitialState() : super();
}

class LoadedState extends OptionsState {
  const LoadedState() : super();
}

class ErrorState extends OptionsState {
  final String message;

  const ErrorState(this.message) : super();

  @override
  List<Object> get props => [message];
}

class OptionsCubit extends ScreenCubit<OptionsState> {
  OptionsCubit() : super(const InitialState());

  void transitionToLoaded() => setState(const LoadedState());

  void transitionToError(String message) => setState(ErrorState(message));

  void transitionToInitial() => setState(const InitialState());
}
