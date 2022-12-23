import 'dart:async';

import '../screen_state.dart';

abstract class ExploreTutorialState extends ScreenState {
  const ExploreTutorialState();
}

class InitialState extends ExploreTutorialState {
  const InitialState() : super();
}

class HoldingState extends ExploreTutorialState {
  final int countdown;
  final Timer timer;

  const HoldingState({
    required this.countdown,
    required this.timer,
  }) : super();

  @override
  List<Object> get props => [countdown];
}

class ExploreTutorialCubit extends ScreenCubit<ExploreTutorialState> {
  ExploreTutorialCubit() : super(const InitialState());

  void transitionToHolding() => setState(
        HoldingState(
          countdown: 3,
          timer: Timer.periodic(
            const Duration(seconds: 1),
            (timer) => decrementCounter(),
          ),
        ),
      );

  void decrementCounter() {
    final holdingState = state as HoldingState;
    setState(
      HoldingState(
        countdown: holdingState.countdown - 1,
        timer: holdingState.timer,
      ),
    );
  }

  void transitionToInitial() {
    if (state is HoldingState) {
      final holdingState = state as HoldingState;
      holdingState.timer.cancel();
      setState(const InitialState());
    }
  }

  @override
  Future<void> close() {
    if (state is HoldingState) {
      final holdingState = state as HoldingState;
      holdingState.timer.cancel();
    }
    return super.close();
  }
}
