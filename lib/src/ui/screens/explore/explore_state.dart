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
  final List<PublicUserEntity> incomingRequests;
  final int pageIndex;

  const LoadedState({
    required this.users,
    required this.incomingRequests,
    required this.pageIndex,
  }) : super();

  @override
  List<Object> get props => [users, pageIndex, incomingRequests];
}

class HoldingState extends ExploreState {
  final List<ExploreUserEntity> users;
  final List<PublicUserEntity> incomingRequests;
  final int pageIndex;
  final int countdown;
  final Timer timer;

  const HoldingState({
    required this.users,
    required this.pageIndex,
    required this.countdown,
    required this.timer,
    required this.incomingRequests,
  }) : super();

  @override
  List<Object> get props => [users, pageIndex, countdown, incomingRequests];
}

class ErrorState extends ExploreState {
  final String message;

  const ErrorState(this.message) : super();

  @override
  List<Object> get props => [message];
}

class EmptyNestState extends ExploreState {
  final List<PublicUserEntity> incomingRequests;

  const EmptyNestState({
    required this.incomingRequests,
  }) : super();

  @override
  List<Object> get props => [incomingRequests];
}

class ExploreCubit extends ScreenCubit<ExploreState> {
  ExploreCubit() : super(const LoadingState());

  void transitionToLoaded(
    List<ExploreUserEntity> users,
    List<PublicUserEntity> incomingRequests,
    int pageIndex,
  ) =>
      setState(
        LoadedState(
          users: users,
          incomingRequests: incomingRequests,
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
        incomingRequests: holdingState.incomingRequests,
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
          incomingRequests: loadedState.incomingRequests,
          users: loadedState.users,
          pageIndex: pageIndex,
        ),
      );
    } else if (state is HoldingState) {
      final holdingState = state as HoldingState;
      setState(
        HoldingState(
          incomingRequests: holdingState.incomingRequests,
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

  void transitionToEmpty(
    List<PublicUserEntity> incomingRequests,
  ) =>
      setState(EmptyNestState(incomingRequests: incomingRequests));

  void removeUser(int index) {
    if (state is LoadedState) {
      final loadedState = state as LoadedState;
      setState(
        LoadedState(
          incomingRequests: loadedState.incomingRequests,
          users: loadedState.users..removeAt(index % loadedState.users.length),
          pageIndex: loadedState.pageIndex,
        ),
      );
    } else if (state is HoldingState) {
      final holdingState = state as HoldingState;
      setState(
        HoldingState(
          incomingRequests: holdingState.incomingRequests,
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

  void addRequest(PublicUserEntity request) {
    if (state is LoadedState) {
      final loadedState = state as LoadedState;
      setState(
        LoadedState(
          incomingRequests: loadedState.incomingRequests..insert(0, request),
          users: loadedState.users,
          pageIndex: loadedState.pageIndex,
        ),
      );
    } else if (state is HoldingState) {
      final holdingState = state as HoldingState;
      setState(
        HoldingState(
          incomingRequests: holdingState.incomingRequests..insert(0, request),
          users: holdingState.users,
          pageIndex: holdingState.pageIndex,
          countdown: holdingState.countdown,
          timer: holdingState.timer,
        ),
      );
    } else {
      throw Exception('Cannot remove user on state: $state');
    }
  }

  void removeRequest(int index) {
    if (state is LoadedState) {
      final loadedState = state as LoadedState;
      setState(
        LoadedState(
          incomingRequests: loadedState.incomingRequests
            ..removeAt(index % loadedState.incomingRequests.length),
          users: loadedState.users,
          pageIndex: loadedState.pageIndex,
        ),
      );
    } else if (state is HoldingState) {
      final holdingState = state as HoldingState;
      setState(
        HoldingState(
          incomingRequests: holdingState.incomingRequests
            ..removeAt(index % holdingState.incomingRequests.length),
          users: holdingState.users,
          pageIndex: holdingState.pageIndex,
          countdown: holdingState.countdown,
          timer: holdingState.timer,
        ),
      );
    } else if (state is EmptyNestState) {
      final emptyNestState = state as EmptyNestState;
      setState(
        EmptyNestState(
          incomingRequests: emptyNestState.incomingRequests
            ..removeAt(
              index % emptyNestState.incomingRequests.length,
            ),
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
          incomingRequests: holdingState.incomingRequests,
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
        incomingRequests: loadedState.incomingRequests,
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
