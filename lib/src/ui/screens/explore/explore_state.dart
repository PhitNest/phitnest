import 'dart:async';

import '../../../entities/entities.dart';
import '../screen_state.dart';

abstract class ExploreState extends ScreenState {
  const ExploreState() : super();
}

class LoadingState extends ExploreState {
  const LoadingState() : super();
}

class LoadedState extends ExploreState {
  final List<ExploreUserEntity> users;
  final int pageIndex;

  const LoadedState({
    required this.users,
    required this.pageIndex,
  }) : super();

  @override
  List<Object> get props => [users, pageIndex];
}

class HoldingState extends ExploreState {
  final List<ExploreUserEntity> users;
  final int pageIndex;
  final int countdown;
  final Timer timer;

  const HoldingState({
    required this.users,
    required this.pageIndex,
    required this.countdown,
    required this.timer,
  }) : super();

  @override
  List<Object> get props => [users, pageIndex, countdown];
}

class ErrorState extends ExploreState {
  final String message;

  const ErrorState(this.message) : super();

  @override
  List<Object> get props => [message];
}

class EmptyNestState extends ExploreState {
  const EmptyNestState() : super();
}

class ExploreCubit extends ScreenCubit<ExploreState> {
  ExploreCubit() : super(const LoadingState());

  void transitionToLoaded({
    required List<ExploreUserEntity> users,
    required int pageIndex,
  }) =>
      setState(
        LoadedState(
          users: users,
          pageIndex: pageIndex,
        ),
      );

  void transitionToLoading() => setState(const LoadingState());

  void transitionToError(String message) => setState(ErrorState(message));

  void decrementCounter() {
    final holdingState = state as HoldingState;
    setState(
      HoldingState(
        users: holdingState.users,
        pageIndex: holdingState.pageIndex,
        countdown: holdingState.countdown - 1,
        timer: holdingState.timer,
      ),
    );
  }

  void setPageIndex(int pageIndex) {
    if (state is LoadedState) {
      final loadedState = state as LoadedState;
      setState(
        LoadedState(
          users: loadedState.users,
          pageIndex: pageIndex,
        ),
      );
    } else if (state is HoldingState) {
      final holdingState = state as HoldingState;
      setState(
        HoldingState(
          users: holdingState.users,
          pageIndex: pageIndex,
          countdown: holdingState.countdown,
          timer: holdingState.timer,
        ),
      );
    } else {
      throw Exception('Cannot set page index on state: $state');
    }
  }

  void transitionToEmpty() => setState(const EmptyNestState());

  void removeUser(int index) {
    if (state is LoadedState) {
      final loadedState = state as LoadedState;
      setState(
        LoadedState(
          users: loadedState.users..removeAt(index),
          pageIndex: loadedState.pageIndex,
        ),
      );
    } else if (state is HoldingState) {
      final holdingState = state as HoldingState;
      setState(
        HoldingState(
          users: holdingState.users
            ..removeAt(index % holdingState.users.length),
          pageIndex: holdingState.pageIndex,
          countdown: holdingState.countdown,
          timer: holdingState.timer,
        ),
      );
    } else {
      throw Exception('Cannot remove user on state: $state');
    }
  }

  void transitionStopHolding() {
    if (state is HoldingState) {
      final holdingState = state as HoldingState;
      holdingState.timer.cancel();
      setState(
        LoadedState(
          users: holdingState.users,
          pageIndex: holdingState.pageIndex,
        ),
      );
    }
  }

  void transitionToHolding() {
    final loadedState = state as LoadedState;
    setState(
      HoldingState(
        users: loadedState.users,
        pageIndex: loadedState.pageIndex,
        countdown: 3,
        timer: Timer.periodic(
          const Duration(seconds: 1),
          (timer) => decrementCounter(),
        ),
      ),
    );
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
