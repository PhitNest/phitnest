import '../screen_state.dart';

abstract class OnBoardingState extends ScreenState {
  const OnBoardingState() : super();
}

class InitialState extends OnBoardingState {
  const InitialState() : super();
}

class LoadedState extends OnBoardingState {
  const LoadedState() : super();
}

class OnBoardingCubit extends ScreenCubit<OnBoardingState> {
  OnBoardingCubit() : super(const InitialState());

  void transitionToLoaded() => setState(const LoadedState());
}
